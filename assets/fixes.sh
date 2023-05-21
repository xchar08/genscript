#!/bin/bash

sudo mkdir -p /root/Desktop

sudo rm -rf /run/user/1000/*
sudo mkdir -p /run/user/1000
sudo chown 1000:1000 /run/user/1000
sudo rc-service dbus restart
sudo rc-service libvirtd restart

cd /home/"$USER"/dotfiles-space/~
cp -r * ~

cp .bashrc ~
cp -r .config ~
cp .fehbg ~
cp -r .scripts ~
cp -r .wallpapers ~
cp .xinirc~

chmod +x /home/"$USER"/.xinitrc
chmod +x /home/"$USER"/.scripts/*
chmod +x ~/.fehbg

curl https://raw.githubusercontent.com/oh-my-fish/oh-my-fish/master/bin/install | fish
curl -sS https://starship.rs/install.sh | sh

sudo emerge kitty
sudo emerge feh

sudo emerge alsa-utils
sudo rc-update add alsasound boot
sudo rc-service alsasound start

echo "fix grub entires"
