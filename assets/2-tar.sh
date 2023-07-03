#!/bin/bash

# read in and unzip the stage 3 tar

echo -n "Enter stage 3 tar url: "
read -r tarurl
wget "$tarurl" /mnt/gentoo/"$tarurl"
tar xvJpf /mnt/gentoo/stage3-*.tar.xz --xattrs --numeric-owner

# prepare for chroot

mkdir -p /mnt/gentoo/etc/portage/repos.conf
cp /mnt/gentoo/usr/share/portage/config/repos.conf /mnt/gentoo/etc/portage/repos.conf/gentoo.conf
cp /etc/resolv.conf /mnt/gentoo/etc/resolv.conf
