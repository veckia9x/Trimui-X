#!/bin/sh


export PATH="/mnt/SDCARD/System/bin:$PATH"
export LD_LIBRARY_PATH="/mnt/SDCARD/System/lib:/usr/trimui/lib:$LD_LIBRARY_PATH"

#=======================
# Variables
#=======================

MYIP=$(ifconfig | grep -A1 wlan0 | grep -m1 inet | awk '{print $2}' | cut -d'/' -f1| cut -d':' -f2 )
BGP=/mnt/SDCARD/Apps/MyIP/bg.png
FONT=/mnt/SDCARD/Apps/MyIP/font.ttf
SEC=10

#=======================
# Functions
#=======================

displaymsg(){
  sdl2imgshow \
    -i "$BGP" \
    -f "$FONT" \
    -s 90 \
    -c "0,0,255" \
    -t "$MYIP" &
  sleep $SEC
  pkill -f sdl2imgshow
}

#=======================
# Runtime
#=======================

if [ $MYIP ]
then
  displaymsg
else
  MYIP="TURN WIFI ON"
  displaymsg
fi

# alpha#9751
# https://github.com/veckia9x/Trimui-X