#!/bin/sh

# some variables needed
BASE_PATH="/mnt/SDCARD/Emus"
TH_PATH=$(grep theme  "/mnt/UDISK/system.json" | cut -d"\"" -f 4)

# functions; dont change anything.
first_run() {
    # Install theme change detection script
    if [ -d "/mnt/SDCARD/System/starts" ]; then
        echo "System/starts folder exists."
    else
        mkdir -p /mnt/SDCARD/System/starts
    fi
    # copy default icons
    mkdir -p /mnt/SDCARD/Themes/themixpro/icon
    bkp_run icon
    # copy default iconsel; not in use but bkps are good
    mkdir -p /mnt/SDCARD/Themes/themixpro/iconsel
    bkp_run iconsel
    # copy default background
    mkdir -p /mnt/SDCARD/Themes/themixpro/background
    bkp_run background
    # Bkp of some default imgs on nand that dont change with themes.
    cp /usr/trimui/res/skin/ic-game-530.png /usr/trimui/res/skin/ic-game-530_og.png
    cp /usr/trimui/res/skin/ic-game-580.png /usr/trimui/res/skin/ic-game-580_og.png
    # Adding iconsel when missing to the config.json 
    find "$BASE_PATH" -type f -name 'config.json' | while read -r file; do
    if grep -q \"iconsel\"\: "$file"; then
        echo
    else
        sed -i '/"background"/i\"iconsel":"",' "$file"
    fi
    done
    # copy and run of the start script
    mv /mnt/SDCARD/Apps/ThemixPro/GREYS-DARK /mnt/SDCARD/Themes/
    cp /mnt/SDCARD/Apps/ThemixPro/ThemixPro.sh /mnt/SDCARD/System/starts/ThemixPro.sh
    sh /mnt/SDCARD/System/starts/ThemixPro.sh &
}

bkp_run() {
    find "$BASE_PATH" -type f -name 'config.json' | while read -r file; do
    local new_img=$(basename "$(dirname "$file")")
    local new_img=$(echo /mnt/SDCARD/Themes/themixpro/$1/$new_img)
    local og_img=$(grep $1\"\: $file | cut -d"\"" -f 4)
    local og_path=$(dirname $file)
    if [ -z $og_img ]; then
        echo "empty var for $og_path"
    else
        cp $og_path\/$og_img $new_img\.png
    fi
    done
}

update_config_file() {
    local file="$1"
    local type="$2"
    local img_name=$(basename "$(dirname "$file")")
    local img_name=$(echo $TH_PATH$type/$img_name | sed 's/\//\\\//g')
    local img_check=$(echo $img_name.png | sed 's/\\\//\//g')
    if [ -f "$img_check" ]; then
        sed -i 's/^ *"'"$type"'".*,/"'"$type"'":"'"$img_name"'.png",/' "$file"
    else
        local def_system=$(basename "$(dirname "$file")")
        if [ "$type" == "iconsel" ]; then
            sed -i 's/^ *"'"$type"'".*,/"'"$type"'":"",/' "$file"
        elif [ -f "$TH_PATH$type/default_override.png" ]; then
            local def_system=$(echo /mnt/SDCARD/Themes/themixpro/$type/default_override | sed 's/\//\\\//g')
            sed -i 's/^ *"'"$type"'".*,/"'"$type"'":"'"$def_system"'.png",/' "$file"
        else
            local def_system=$(echo /mnt/SDCARD/Themes/themixpro/$type/$def_system | sed 's/\//\\\//g')
            sed -i 's/^ *"'"$type"'".*,/"'"$type"'":"'"$def_system"'.png",/' "$file"
        fi
    fi
}

update_configs() {
    find "$BASE_PATH" -type f -name 'config.json' | while read -r file; do
        update_config_file "$file" icon
        update_config_file "$file" iconsel
        update_config_file "$file" background
    done
    local th_name=$(echo $TH_PATH | cut -d"/" -f5)
    # removal of symbolic link/file
    rm /usr/trimui/res/skin/ic-game-530.png
    rm /usr/trimui/res/skin/ic-game-580.png
    # Symlinking some imgs on nand that dont change with themes.
    ln -s /mnt/SDCARD/Themes/$th_name/skin/ic-game-530.png /usr/trimui/res/skin/ic-game-530.png
    ln -s /mnt/SDCARD/Themes/$th_name/skin/ic-game-580.png /usr/trimui/res/skin/ic-game-580.png
    # update of the themes path to check file
    echo $TH_PATH > /mnt/SDCARD/Apps/ThemixPro/theme
    # restart of the interface
    echo "All config.json files have been updated."
    kill -9 $(pidof MainUI)
}

# run time.
if [ -f "/mnt/SDCARD/System/starts/ThemixPro.sh" ]; then
    update_configs
else
    first_run
fi

# alpha#9751
# https://github.com/veckia9x/Trimui-X