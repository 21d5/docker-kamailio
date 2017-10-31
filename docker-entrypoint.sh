#!/bin/bash
set -e
shopt -s extglob

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
  if [ "$k" == "DEF_LISTEN" ]; then
    # The listen parameter expects a complex value, which cannot be quoted
    def="$def $v"
  else
    case $v in
      ''       ) ;;
      +([0-9]) ) def="$def $v" ;;
      *        ) def="$def \"$v\"" ;;
    esac
  fi

  echo $def >> $file
done

if [ "$DBENGINE" == "postgres" ] && [ -n "$DBHOST" ]; then
  export PGHOST=$DBHOST PGPORT=$DBPORT PGDATABASE=$DBNAME
  while ! pg_isready > /dev/null 2> /dev/null; do
    echo "Connection check for database $PGHOST:$PGPORT failed. Retry in 5s..."
    sleep 5
  done

  if [ -n "$DBROOTUSER" ] && [ -n "$DBROOTPW" ]; then
    if ! PGPASSWORD=$DBROOTPW psql -lqt -U $DBROOTUSER | cut -d \| -f 1 | grep -qw $DBNAME; then
      PGPASSWORD=$DBROOTPW kamdbctl create
    fi
  fi
fi

if [ "$1" = 'kamailio' ]; then
  exec chroot --userspec=kamailio / /usr/sbin/kamailio -DD -E -m $SHM_MEMORY -M $PKG_MEMORY -u kamailio -g kamailio
fi

exec "$@"
