#!/bin/bash

#fonts
sudo emerge media-fonts/source-pro --autounmask{,-write,-continue}
sudo emerge media-fonts/noto-emoji --autounmask{,-write,-continue}
sudo emerge media-fonts/noto --autounmask{,-write,-continue}

#terminal
echo -n "Select terminal (alacritty, kitty, xterm, st): "
read -r term
case "$term" in
"alacritty") sudo emerge x11-terms/alacritty --autounmask{,-write,-continue} ;;
"kitty") sudo emerge x11-terms/kitty --autounmask{,-write,-continue} ;;
"xterm") sudo emerge x11-terms/xterm --autounmask{,-write,-continue} ;;
"st") sudo emerge x11-terms/st --autounmask{,-write,-continue} ;;
esac    