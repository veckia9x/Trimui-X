#!/bin/sh

HOMEBIN=/mnt/SDCARD/System/syncthing

cd $HOMEBIN
./syncthing serve --no-restart --no-upgrade --config="$HOMEBIN" --data="$HOMEBIN/data" > /dev/null &

# alpha#9751
# https://github.com/veckia9x/Trimui-X