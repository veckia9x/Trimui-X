#!/bin/sh

SYSTEM_JSON="/mnt/UDISK/system.json"
THEME_NAME_FILE="/mnt/SDCARD/Apps/ThemixPro/theme"
LAUNCH_SCRIPT="/mnt/SDCARD/Apps/ThemixPro/launch.sh"
last_modified=$(stat -c %Y "$SYSTEM_JSON")

check_theme() {
    theme_name=$(cat "$THEME_NAME_FILE" | cut -d "/" -f5)
    if grep -q "\"theme\":\s*\"/mnt/SDCARD/Themes/$theme_name/\"" "$SYSTEM_JSON"; then
        echo "Theme in use: $theme_name"
    else
        sh "$LAUNCH_SCRIPT"
    fi
}

run_main() {
    while true; do
        current_modified=$(stat -c %Y "$SYSTEM_JSON")
        if [ "$current_modified" -gt "$last_modified" ]; then
            echo "File $SYSTEM_JSON was modified. Checking theme..."
            check_theme
            last_modified=$current_modified
        fi
        sleep 10
    done
}

run_main &

# alpha#9751
# https://github.com/veckia9x/Trimui-X