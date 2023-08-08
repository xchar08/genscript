#!/bin/bash

change_directory() {
    local directory="$1"
    cd "$directory" || exit
}

read_and_unzip_stage3() {
    echo -n "Enter stage 3 tar url: "
    read -r tarurl
    wget "$tarurl"
    tar xvJpf stage3-*.tar.xz --xattrs --numeric-owner
}

prepare_for_chroot() {
    mkdir -p /mnt/gentoo/etc/portage/repos.conf
    cp /mnt/gentoo/usr/share/portage/config/repos.conf /mnt/gentoo/etc/portage/repos.conf/gentoo.conf
    cp /etc/resolv.conf /mnt/gentoo/etc/resolv.conf
}

# Change directory
change_directory "/mnt/gentoo"

# Read in and unzip the stage 3 tar
read_and_unzip_stage3

# Prepare for chroot
prepare_for_chroot
