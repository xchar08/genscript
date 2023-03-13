#!/bin/bash

# read in needed volumes

partuuid=$(blkid | grep "crypto_LUKS" | sed -n 's/.*PARTUUID=\"\([^\"]*\)\".*/\1/p')
echo -n 'Enter efi partition (e.g. nvme0n1p1): '
read -r efipart
echo -n 'Enter boot partition (e.g. nvme0n1p2): '
read -r bootpart

# mount necessary volumes 

cd /dev/mapper || exit
mkfs.btrfs /dev/mapper/luks-"$partuuid"
mkdir /mnt/btrfs
mount /dev/mapper/luks-"$partuuid" /mnt/btrfs
cd /mnt/btrfs || exit
btrfs subvolume create ./root
btrfs subvolume create ./home
mkdir -p /mnt/gentoo
mount -o subvol=root /dev/mapper/luks-"$partuuid" /mnt/gentoo
mkdir /mnt/gentoo/boot
mkdir /mnt/gentoo/home
mount -o subvol=home /dev/mapper/luks-"$partuuid" /mnt/gentoo/home
mount /dev/"$bootpart" /mnt/gentoo/boot
mkdir /mnt/gentoo/boot/efi
mount /dev/"$efipart" /mnt/gentoo/boot/efi
cd /mnt/gentoo || exit

# read in and unzip the stage 3 tar

echo -n "Enter stage 3 tar url: "
read -r tarurl
wget "$tarurl"
tar xvJpf stage3-*.tar.xz --xattrs --numeric-owner

#create the makefile

echo 'COMMON_FLAGS="-O2 -march=native -pipe"
CFLAGS="${COMMON_FLAGS}"
CXXFLAGS="${COMMON_FLAGS}"
FCFLAGS="${COMMON_FLAGS}"
FFLAGS="${COMMON_FLAGS}"
MAKEOPTS="-j8"
ACCEPT_KEYWORDS="~amd64"
ACCEPT_LICENSE="*"' | sudo tee /etc/portage/make.conf
echo -n "Enter the video cards string: "
read video_cards
echo 'VIDEO_CARDS="'$video_cards'"' | sudo tee -a /etc/portage/make.conf
echo -n "Enter the USE flags: "
read use_flags
echo 'USE="'$use_flags'"' | sudo tee -a /etc/portage/make.conf
echo 'PORTDIR="/var/db/repos/gentoo"
DISTDIR="/var/cache/distfiles"
PKGDIR="/var/cache/binpkgs"

# This sets the language of build output to English.
# Please keep this setting intact when reporting bugs.
LC_MESSAGES=C
GENTOO_MIRRORS="https://mirror.leaseweb.com/gentoo/ http://mirror.leaseweb.com/gentoo/ rsync://mirror.leaseweb.com/gentoo/"' | sudo tee /etc/portage/make.conf

# prepare for chroot

mkdir /mnt/gentoo/etc/portage/repos.conf
cp /mnt/gentoo/usr/share/portage/config/repos.conf /mnt/gentoo/etc/portage/repos.conf/gentoo.conf
cp /etc/resolv.conf /mnt/gentoo/etc/resolv.conf
