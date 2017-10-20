#!/bin/bash
set -e

prefix='DEF_'
file='/etc/kamailio/kamailio-local.cfg'
cat > $file
printenv | grep "^$prefix" | while read -r env; do
  k=${env%=*}
  v=${env#*=}

  case ${v,,} in
    true|yes|on)  v=1 ;;
    false|no|off) v=0 ;;
  esac

  def="#!define ${k#$prefix}"
  case $v in
    '')      ;;
    *[0-9]*) def="$def $v" ;;
    *)       def="$def \"$v\"" ;;
  esac

  echo $def >> $file
done

if [ "$1" = 'kamailio' ]; then
  exec chroot --userspec=kamailio / /usr/sbin/kamailio -DD -E -m $SHM_MEMORY -M $PKG_MEMORY -u kamailio -g kamailio
fi

exec "$@"
