#!/bin/bash
set -e

if [ "$1" = 'kamailio' ]; then
  exec chroot --userspec=kamailio / /usr/sbin/kamailio -DD -E -m $SHM_MEMORY -M $PKG_MEMORY -u kamailio -g kamailio
fi

exec "$@"
