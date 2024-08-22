#!/bin/bash

echo "Please enter your username:"
read -r us

sudo emerge x11-wm/bspwm --autounmask{,-write,-continue}
sudo emerge x11-misc/sxhkd --autounmask{,-write,-continue}

# mkdir
mkdir -p /home/$us/wallpapers
mkdir -p /home/$us/.config/bspwm
mkdir -p /home/$us/.config/kitty
mkdir -p /home/$us/.config/polybar/modules
mkdir -p /home/$us/.config/rofi
mkdir -p /home/$us/.config/sxhkd

# wget
wget -O /home/$us/.xinitrc https://raw.githubusercontent.com/xchar08/genscript/main/assets/bspwm/.xinitrc
wget -O /home/$us/.fehbg https://raw.githubusercontent.com/xchar08/genscript/main/assets/bspwm/.fehbg
wget -O /home/$us/wallpapers/wallpaper.png https://github.com/xchar08/genscript/blob/main/assets/bspwm/wallpapers/wallpaper.png?raw=true

wget -O /home/$us/.config/picom.conf https://raw.githubusercontent.com/xchar08/genscript/main/assets/bspwm/.config/picom.conf

wget -O /home/$us/.config/bspwm/bspwmrc https://raw.githubusercontent.com/xchar08/genscript/main/assets/bspwm/.config/bspwm/bspwmrc
wget -O /home/$us/.config/kitty/kitty.conf https://raw.githubusercontent.com/xchar08/genscript/main/assets/bspwm/.config/kitty/kitty.conf
wget -O /home/$us/.config/polybar/config.ini https://raw.githubusercontent.com/xchar08/genscript/main/assets/bspwm/.config/polybar/config.ini
wget -O /home/$us/.config/polybar/launch.sh https://raw.githubusercontent.com/xchar08/genscript/main/assets/bspwm/.config/polybar/launch.sh
wget -O /home/$us/.config/polybar/modules/modules.ini https://raw.githubusercontent.com/xchar08/genscript/main/assets/bspwm/.config/polybar/modules/modules.ini
wget -O /home/$us/.config/polybar/modules/user_modules.ini https://raw.githubusercontent.com/xchar08/genscript/main/assets/bspwm/.config/polybar/modules/user_modules.ini
wget -O /home/$us/.config/rofi/config.rasi https://raw.githubusercontent.com/xchar08/genscript/main/assets/bspwm/.config/rofi/config.rasi
wget -O /home/$us/.config/rofi/theme.rasi https://raw.githubusercontent.com/xchar08/genscript/main/assets/bspwm/.config/rofi/theme.rasi
wget -O /home/$us/.config/sxhkd/sxhkdrc https://raw.githubusercontent.com/xchar08/genscript/main/assets/bspwm/.config/sxhkd/sxhkdrc

chmod +x /home/$us/.config/polybar/launch.sh

