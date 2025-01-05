
#!/bin/bash

TERMINAL=kitty
TERMINAL_PATH=/usr/bin/kitty


for app in $(grep -rl Terminal=true /usr/share/applications)
do
  dot_desktop=~/.local/share/applications/$(basename $app)
  sed 's\Exec=\Exec=$TERMINAL_PATH -c \' $app > "$dot_desktop"
  sed -i 's\Terminal=true\Terminal=false\g'  "$dot_desktop"
  sed -i '/TryExec/d'  "$dot_desktop"
  chmod +x "$dot_desktop"
done

sudo update-alternatives --install /usr/bin/x-terminal-emulator x-terminal-emulator $TERMINAL_PATH 50

#Now we set it the default 
sudo update-alternatives --set x-terminal-emulator  $TERMINAL_PATH

# make gnome use it
gsettings set org.gnome.desktop.default-applications.terminal exec x-terminal-emulator

sudo apt install python3-nautilus python3-full -y
pip install --user nautilus-open-any-terminal --break-system-packages
glib-compile-schemas ~/.local/share/glib-2.0/schemas


gsettings set com.github.stunkymonkey.nautilus-open-any-terminal terminal $TERMINAL
gsettings set com.github.stunkymonkey.nautilus-open-any-terminal new-tab false

# add keyboard shortcut
gsettings set org.gnome.settings-daemon.plugins.media-keys custom-keybindings "['/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/']"

gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ name $TERMINAL
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ command $TERMINAL_PATH
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ binding "<Ctrl><Alt>t"

# restart nautilus
nautilus -q 

# done
