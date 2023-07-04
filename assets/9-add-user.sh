#!/bin/bash

#create user and configure sudo

sudo cp /root/gentoo-secured-dwl/assets/package.use /etc/portage/package.use

sudo emerge dev-vcs/git --autounmask{,-write,-continue}

emerge app-admin/sudo --autounmask{,-write,-continue}

echo "Please enter the username you would like to create in Gentoo:"
read -r us
useradd "$us"
groupadd user
usermod -aG wheel,video,audio,user,portage,plugdev "$us"
echo "$us" | sudo tee /etc/hostname
echo "%wheel ALL=(ALL:ALL) ALL" | sudo tee -a /etc/sudoers
echo -e "Defaults rootpw\nDefaults !tty_tickets" | sudo tee -a /etc/sudoers
passwd "$us"
mkdir -p /root/Desktop
