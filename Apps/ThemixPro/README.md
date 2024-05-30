## ThemixPro

### On first run
So on the first run it will try to copy the default `icon`, `iconsel` and `background` as defined in each Emu `config.json` to a folder called `themixpro` located inside the Themes folder.

A bkp of original `ic-game-530.png` and `ic-game-580.png` is made.
It will also include an entry for iconsel on all Emus that are missing it in its config.json.

### Changing a theme

When the user changes the theme a script in loop detect (up to 10s to detect) and start to make changes.

These changes verify if the Theme has an icon folder with the proper icon for each Emu, each Emu is treated individually.
If the icon is present inside the `new theme folder/icon` then it updates the config.json with this information.
If the icon isnt present then it writes the default bkp location to the original icon, this way not one system stays without an icon.

Same for backgrounds, so if you want a black background on all systems you should put a `default_override.png` under `your theme folder/background`.

Iconsel is the only one that defaults to nothing if an replacement isnt found in `your theme folder/iconsel`, until I can figure it out whats the best to do.

Each time a symlink is done to the `ic-game-530.png` and `ic-game-580.png` to reflect the theme changes on new theme.

A restart trigger on the interface ensures the user sees the changes on `icon`, `iconsel` and `background`.

### Know bugs  
- I already found a bug that will fail to create a bkp of the default icons if you used ThemixPro on beta.