#!/bin/sh


export PATH="/mnt/SDCARD/System/bin:$PATH"
export LD_LIBRARY_PATH="/mnt/SDCARD/System/lib:/usr/trimui/lib:$LD_LIBRARY_PATH"
export EX_CONFIG_PATH="/mnt/SDCARD/System/etc"
export EX_RESOURCE_PATH="/mnt/SDCARD/System/resources"

#=======================
# Var. Def.
#=======================

MYIP=$(ip addr show wlan0 | grep -m1 inet | awk '{print $2}' | cut -d'/' -f1)

#=======================
# SHOW TIME!
#=======================

sdl2imgshow \
    -i "/mnt/SDCARD/Apps/MyIP/bg.png" \
    -f "/mnt/SDCARD/Apps/MyIP/font.ttf" \
    -s 90 \
    -c "0,0,255" \
    -t "$MYIP" &

sleep 10

pkill -f sdl2imgshow

# alpha#9751
# https://github.com/veckia9x/Trimui-X