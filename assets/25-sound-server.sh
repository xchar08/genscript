#!/bin/bash

#installation
sudo emerge sys-firmware/sof-firmware --autounmask{,-write,-continue}
sudo emerge media-sound/pulseaudio --autounmask{,-write,-continue}
sudo emerge media-libs/libpulse --autounmask{,-write,-continue}
sudo emerge media-video/wireplumber --autounmask{,-write,-continue}

#configuration
sudo cp /usr/share/pipewire/pipewire.conf /etc/pipewire/pipewire.conf
cp /usr/share/pipewire/pipewire.conf /etc/pipewire/pipewire.conf

#groupadd
sudo usermod -aG audio "$USER"

#profile
echo '
# Ensure XDG_RUNTIME_DIR is set
if test -z "$XDG_RUNTIME_DIR"; then
    export XDG_RUNTIME_DIR=$(mktemp -d /tmp/$(id -u)-runtime-dir.XXX)
fi
' > ~/.bash_profile

source ~/.bash_profile

