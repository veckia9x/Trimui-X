#!/bin/sh

# some variables needed
BASE_PATH="/mnt/SDCARD/Emus"
TH_PATH=$(grep theme  "/mnt/UDISK/system.json" | cut -d"\"" -f 4)

# functions; dont change anything.
first_run() {
    # Install theme change detection script
    if [ -f "/mnt/SDCARD/System/starts/ThemixPro.sh" ]; then
        echo "Already installed!"
    else
        if [ -d "/mnt/SDCARD/System/starts" ]; then
            echo "System/starts folder exists."
        else
                mkdir -p /mnt/SDCARD/System/starts
        fi
        # copy default icons
        mkdir -p /mnt/SDCARD/Themes/themixpro/icon
        find "$BASE_PATH" -type f -name 'config.json' | while read -r file; do
        local icon_name=$(basename "$(dirname "$file")")
        local icon_name=$(echo /mnt/SDCARD/Themes/themixpro/icon/$icon_name)
        local og_icon=$(grep icon\"\: $file | cut -d"\"" -f 4)
        local og_path=$(dirname $file)
        cp $og_path$og_icon $icon_name\.png
        echo "Icon $file copy done."
        done

        # copy default iconsel
        mkdir -p /mnt/SDCARD/Themes/themixpro/iconsel
        find "$BASE_PATH" -type f -name 'config.json' | while read -r file; do
        local icon_name=$(basename "$(dirname "$file")")
        local icon_name=$(echo /mnt/SDCARD/Themes/themixpro/iconsel/$icon_name)
        local og_icon=$(grep iconsel\"\: $file | cut -d"\"" -f 4)
        local og_path=$(dirname $file)
        cp $og_path$og_icon $icon_name\.png
        echo "Iconsel $file copy done."
        done

        # copy default bg
        mkdir -p /mnt/SDCARD/Themes/themixpro/bg
        find "$BASE_PATH" -type f -name 'config.json' | while read -r file; do
        local icon_name=$(basename "$(dirname "$file")")
        local icon_name=$(echo /mnt/SDCARD/Themes/themixpro/bg/$icon_name)
        local og_icon=$(grep background\"\: $file | cut -d"\"" -f 4)
        local og_path=$(dirname $file)
        cp $og_path$og_icon $icon_name\.png
        echo "Bg $file copy done."
        done

        cp /mnt/SDCARD/Apps/ThemixPro/ThemixPro.sh /mnt/SDCARD/System/starts/ThemixPro.sh
        sh /mnt/SDCARD/System/starts/ThemixPro.sh &
    fi
}

update_config_file() {
    local file="$1"
    local type="icon/"
    local icon_name=$(basename "$(dirname "$file")")
    local icon_name=$(echo $TH_PATH$type$icon_name | sed 's/\//\\\//g')    ### STILL NEEDS TYPE VAR DEF ACTUALLY VARIABLE DEFINITION!!!
    sed -i 's/^ *"icon".*,/"icon":"'"$icon_name"'.png",/' "$file"
    echo "Updated $file"
}

update_configs() {
    find "$BASE_PATH" -type f -name 'config.json' | while read -r file; do
        update_config_file "$file"
    done
    local v_ui=$(top -n1 | grep -m1 "MainUI" | cut -d" " -f 2)
    kill -9 $v_ui
    echo $TH_PATH > /mnt/SDCARD/Apps/ThemixPro/theme
    echo "All config.json files have been updated."
}

# run time.
first_run
update_configs


# alpha#9751
# https://github.com/veckia9x/Trimui-X