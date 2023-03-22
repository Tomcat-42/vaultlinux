#!/bin/bash
set -e
[ $# -eq 0 ] && set -- yocto
if [ "$1" = "yocto" ]; then
	shift
	set -- "$YOCTO_ENTRYPOINT" "$@"
fi
exec "$@"
