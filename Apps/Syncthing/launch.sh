#!/bin/sh


export PATH="/mnt/SDCARD/System/bin:$PATH"
export LD_LIBRARY_PATH="/mnt/SDCARD/System/lib:/usr/trimui/lib:$LD_LIBRARY_PATH"
export EX_CONFIG_PATH="/mnt/SDCARD/System/etc"
export EX_RESOURCE_PATH="/mnt/SDCARD/System/resources"

#=======================
# Var. Def.
#=======================

HOMEAPP=/mnt/SDCARD/Apps/Syncthing
HOMEBIN=/mnt/SDCARD/System/syncthing
SYNCUSER=trimui
SYNCPASS=trimuisync

# DO NOT CHANGE THIS UNLESS YOU ABSOLUTELLY KNOWS WHAT YOURE DOING!
DLINK=http://bin.entware.net/armv7sf-k3.2/syncthing_1.27.3-1_armv7-3.2.ipk

#=======================
# install if needed
#=======================

if [ -d "$HOMEBIN/" ]; then
  echo installed
else
  sdl2imgshow \
    -i "$HOMEAPP/installbg.png" \
    -f "$HOMEAPP/font.ttf" \
    -s 90 \
    -c "255,0,0" \
    -t "Installing Syncthing 1.27.3" &

  # keep device on
  echo 1 > /tmp/stay_awake
  # download pkg
  wget -O $HOMEAPP/syncthing_pkg.ipk $DLINK
  # extract pkg
  tar zxvf syncthing_pkg.ipk
  tar zxvf data.tar.gz
  # make dir and move to right place
  mkdir -p $HOMEBIN/data
  mv $HOMEAPP/opt/bin/syncthing $HOMEBIN/
  # some cleanup.
  cd $HOMEAPP/
  rm -rf control* opt/ data* debian* syncthing_pkg.ipk
  # syncthing basic setup
  cd $HOMEBIN/
  ./syncthing generate --no-default-folder --gui-user="$SYNCUSER" --gui-password="$SYNCPASS" --config="$HOMEBIN"
  #allow for external connections
  sed -i 's|127\.0\.0\.1|0.0.0.0|' $HOMEBIN/config.xml
  # re-enable devices ability to sleep
  rm /tmp/stay_awake
  pkill -f sdl2imgshow
fi

#=======================
# Start/Stop 
#=======================

#check status
if [ -f $HOMEAPP/status.lock ]; then
  echo Stopping syncthing
  kill -2 $(pidof syncthing)
  kill -9 $(pidof syncthing)
  rm -rf $HOMEAPP/status.lock
else
  echo Starting syncthing
  cd $HOMEBIN
  ./syncthing serve --no-restart --no-upgrade --config="$HOMEBIN" --data="$HOMEBIN/data" > /dev/null &
  touch $HOMEAPP/status.lock
fi

# alpha#9751
# https://github.com/veckia9x/Trimui-X