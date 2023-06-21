#!/bin/bash

#fonts
emerge media-fonts/source-pro --autounmask{,-write,-continue}
emerge media-fonts/noto-emoji --autounmask{,-write,-continue}
emerge media-fonts/noto --autounmask{,-write,-continue}

#terminal
echo -n "Select terminal (alacritty, kitty, xterm): "
read -r term
case "$term" in
"alacritty") emerge x11-terms/alacritty --autounmask{,-write,-continue} ;;
"kitty") emerge x11-terms/kitty --autounmask{,-write,-continue} ;;
"xterm") emerge x11-terms/xterm --autounmask{,-write,-continue} ;;
esac    