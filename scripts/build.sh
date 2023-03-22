#!/bin/bash

WORKDIR="$PWD"

sed -i "s|^WORKDIR=.*$|WORKDIR=\"${WORKDIR}\"|" ./scripts/yocto-entrypoint.sh

docker run -i -t --rm \
  --device=/dev/net/tun \
	-v "$WORKDIR:$WORKDIR" \
	-v "$PWD"/scripts/yocto-entrypoint.sh:/yocto-entrypoint.sh \
	vaultlinux:latest \
	yocto "$@"
