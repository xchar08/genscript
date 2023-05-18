#!/bin/bash

# read in needed volumes

partuuid=$(blkid | grep "crypto_LUKS" | sed -n 's/.*PARTUUID=\"\([^\"]*\)\".*/\1/p')
echo -n 'Enter efi partition (e.g. nvme0n1p1): '
read -r efipart
echo -n 'Enter boot partition (e.g. nvme0n1p2): '
read -r bootpart

# Create Btrfs filesystem and subvolumes
mkfs.btrfs /dev/mapper/luks-"$partuuid"
mount /dev/mapper/luks-"$partuuid" /mnt

cd /mnt || exit
btrfs subvolume create ./root
btrfs subvolume create ./var
btrfs subvolume create ./tmp
btrfs subvolume create ./home

# Mount partitions
mkdir /mnt/gentoo
mount -o subvol=root /dev/mapper/luks-"$partuuid" /mnt/gentoo

mkdir /mnt/gentoo/{boot,home,var,tmp}
mount -o subvol=home /dev/mapper/luks-"$partuuid" /mnt/gentoo/home
mount -o subvol=var /dev/mapper/luks-"$partuuid" /mnt/gentoo/var
mount -o subvol=tmp /dev/mapper/luks-"$partuuid" /mnt/gentoo/tmp

mount /dev/"$bootpart" /mnt/gentoo/boot
mkdir /mnt/gentoo/boot/efi
mount /dev/"$efipart" /mnt/gentoo/boot/efi

cd /mnt/gentoo || exit

# read in and unzip the stage 3 tar

echo -n "Enter stage 3 tar url: "
read -r tarurl
wget "$tarurl"
tar xvJpf stage3-*.tar.xz --xattrs --numeric-owner

# prepare for chroot

mkdir /mnt/gentoo/etc/portage/repos.conf
cp /mnt/gentoo/usr/share/portage/config/repos.conf /mnt/gentoo/etc/portage/repos.conf/gentoo.conf
cp /etc/resolv.conf /mnt/gentoo/etc/resolv.conf
