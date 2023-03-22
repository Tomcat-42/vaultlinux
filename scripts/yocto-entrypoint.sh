#!/bin/bash

SUPPORTED_MACHINES="qemuarm qemuarm64 qemumips qemumips64 qemuppc qemux86 qemux86-64 beaglebone-yocto genericx86 genericx86-64 mpc8315e-rdb edgerouter"

SUPPORTED_YOCTO="sumo"
WORKDIR="/mnt/files/projects/bry/vaultlinux"

yocto_sync() {
	if [ -d "$WORKDIR"/yocto/sources/poky ]; then
		cd "$WORKDIR"/yocto/sources/poky
		git fetch origin
		git checkout origin/"$1"
	else
		mkdir -p "${WORKDIR}/yocto/sources"
		cd "${WORKDIR}/yocto/sources"
		git clone -b "$1" git://git.yoctoproject.org/poky.git
	fi
}

is_in_list() {
	local key="$1"
	local list="$2"

	for item in ${list[@]}; do
		if [ "$item" = "$key" ]; then
			return 0
		fi
	done

	return 1
}

is_machine_supported() {
	local MACHINE="$1"

	is_in_list "$MACHINE" "$SUPPORTED_MACHINES"
}

is_yocto_supported() {
	local YOCTO="$1"

	is_in_list "$YOCTO" "$SUPPORTED_YOCTO"
}

show_usage() {
	echo "Usage: StartBuild.sh command [args]"
	echo "Commands:"
	echo " sync "
	echo " Sync Yocto version"
	echo " E.g. sync quemux86 warrior"
	echo
	echo " all"
	echo " Build Yocto"
	echo
	echo " bash"
	echo " Start an interactive bash shell"
	echo
	echo " help"
	echo " Show this text"
	echo
	exit 1
}

main() {
	if [ $# -lt 1 ]; then
		show_usage
	fi

	if [ ! -d "${WORKDIR}/yocto/sources" ] && [ "$1" != "sync" ]; then
		echo "The directory 'yocto/sources' does not yet exist. Use the 'sync' command"
		show_usage
	fi

	case "$1" in
	all)
		cd "$WORKDIR"/yocto/
		source sources/poky/oe-init-build-env build
		bitbake core-image-minimal
		;;

	sync)
		shift
		set -- "$@"
		if [ $# -ne 2 ]; then
			echo "sync command accepts only 2 arguments"
			show_usage
		fi

		if ! is_machine_supported "$1"; then
			echo "$1 is not a supported machine: ${SUPPORTED_MACHINES}"
			show_usage
		fi

		if ! is_yocto_supported "$2"; then
			echo "$2 is not a supported yocto version: ${SUPPORTED_YOCTO}"
			show_usage
		fi

		yocto_sync "$2"

		cd "${WORKDIR}/yocto"
		source sources/poky/oe-init-build-env build
		sed -i "s/^MACHINE ??= .*$/MACHINE ??= \"$1\"/" conf/local.conf
		;;

	bash)
		cd "${WORKDIR}/yocto"
		source sources/poky/oe-init-build-env build
		bash
		;;

	help)
		show_usage
		;;

	*)
		echo "Command not supported: $1"
		show_usage
		;;
	esac
}

main "$@"
