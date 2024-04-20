#!/bin/sh

HOMEAPP=/mnt/SDCARD/Apps/Syncthing
HOMEBIN=/mnt/SDCARD/System/syncthing

#=======================
# install if needed
#=======================

if [ -d "/mnt/SDCARD/System/syncthing/" ]; then
  echo installed
else
  #sdl2imgshow \
  #  -i "/mnt/SDCARD/Apps/Syncthing/installbg.png" \
  #  -f "/mnt/SDCARD/Apps/Syncthing/font.ttf" \
  #  -s 48 \
  #  -c "0,0,0" \
  #  -t "Installing Syncthing 1.27.3" &

  # keep device on
  echo 1 > /tmp/stay_awake
  # download pkg
  wget -O /mnt/SDCARD/Apps/Syncthing/syncthing_pkg.ipk http://bin.entware.net/armv7sf-k3.2/syncthing_1.27.3-1_armv7-3.2.ipk
  # extract pkg
  tar zxvf syncthing_pkg.ipk
  tar zxvf data.tar.gz
  # make dir and move to right place
  mkdir -p /mnt/SDCARD/System/syncthing/data
  mv /mnt/SDCARD/Apps/Syncthing/opt/bin/syncthing /mnt/SDCARD/System/syncthing/
  # some cleanup.
  cd /mnt/SDCARD/Apps/Syncthing/
  rm -rf control* opt/ data* debian* syncthing_pkg.ipk
  # syncthing basic setup
  cd /mnt/SDCARD/System/syncthing/
  ./syncthing generate --no-default-folder --gui-user="trimui" --gui-password="trimuisync" --config="/mnt/SDCARD/System/syncthing"
  #allow for external connections
  sed -i 's|127\.0\.0\.1|0.0.0.0|' /mnt/SDCARD/System/syncthing/config.xml
  # re-enable devices ability to sleep
  rm /tmp/stay_awake
  #pkill -f sdl2imgshow
fi

#=======================
# Start/Stop 
#=======================

#check status
if [ -f /mnt/SDCARD/Apps/Syncthing/status.lock ]; then
  echo Stopping syncthing
  kill -2 $(pidof syncthing)
  kill -9 $(pidof syncthing)
  rm -rf /mnt/SDCARD/Apps/Syncthing/status.lock
else
  echo Starting syncthing
  cd /mnt/SDCARD/System/syncthing
  ./syncthing serve --no-restart --no-upgrade --config="/mnt/SDCARD/System/syncthing" --data="/mnt/SDCARD/System/syncthing/data" > /dev/null &
  touch /mnt/SDCARD/Apps/Syncthing/status.lock
fi

# alpha#9751 / veckia9x