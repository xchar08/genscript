#!/bin/bash

#sudo emerge x11-apps/xlsclients --autounmask{,-write,-continue}
#sudo emerge gui-libs/wlroots --autounmask{,-write,-continue}
sudo emerge dev-libs/wayland-protocols --autounmask{,-write,-continue}

#groupadd
sudo usermod -aG video "$USER"
sudo usermod -aG input "$USER"

#XDG_RUNTIME_DIR
#export XDG_RUNTIME_DIR=/tmp/xdg-runtime-$(id -u)
#mkdir -p $XDG_RUNTIME_DIR
#dwl

sudo mkdir -p /etc/portage/patches/
