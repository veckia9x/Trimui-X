#!/bin/sh

# Install theme change detection script

if [ -f "/mnt/SDCARD/System/starts/ThemixPro.sh" ]; then
    echo "Already installed!"
else
    cp /mnt/SDCARD/Apps/ThemixPro/ThemixPro.sh /mnt/SDCARD/System/starts/ThemixPro.sh
    reboot
fi

# some variables needed

BASE_PATH="/mnt/SDCARD/Emus"
TH_PATH=$(grep theme  "/mnt/UDISK/system.json" | cut -d"\"" -f 4)

# functions; dont change anything.

update_config_file() {
    local file="$1"
    local type="icon/"
    local icon_name=$(basename "$(dirname "$file")")
    local icon_name=$(echo $TH_PATH$type$icon_name | sed 's/\//\\\//g')
    sed -i 's/^ *"icon".*,/"icon":"'"$icon_name"'.png",/' "$file"
    echo "Updated $file"
}

update_all_configs() {
    find "$BASE_PATH" -type f -name 'config.json' | while read -r file; do
        update_config_file "$file"
    done
    local v_ui=$(top -n1 | grep -m1 "MainUI" | cut -d" " -f 2)
    kill -9 $v_ui
    echo $TH_PATH > /mnt/SDCARD/Apps/ThemixPro/theme
    echo "All config.json files have been updated."
}

update_all_configs


# alpha#9751
# https://github.com/veckia9x/Trimui-X