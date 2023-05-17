#!/bin/bash

# read in all volumes 
partuuid=$(blkid | grep "crypto_LUKS" | sed -n 's/.*PARTUUID=\"\([^\"]*\)\".*/\1/p')

echo -n 'Enter device label (e.x. nvme0n1): '
read -r primpart
echo -n 'Enter efi partition (e.x. nvme0n1p1): '
read -r efipart
echo -n 'Enter boot partition (e.x. nvme0n1p2): '
read -r bootpart
echo -n 'Enter root partition (e.x. nvme0n1p3): '
read -r rootpart

# Create partitions
parted -a optimal /dev/"$primpart" -- mklabel gpt
parted -a optimal /dev/"$primpart" -- mkpart ESP fat32 0% 512MiB
parted -a optimal /dev/"$primpart" -- mkpart swap linux-swap 512MiB 8.75GiB
parted -a optimal /dev/"$primpart" -- mkpart rootfs btrfs 8.75GiB 70%
parted -a optimal /dev/"$primpart" -- mkpart var btrfs 70% 90%
parted -a optimal /dev/"$primpart" -- mkpart tmp btrfs 90% 100%
parted -a optimal /dev/"$primpart" -- set 1 boot on

# Format partitions
mkfs.fat -F32 /dev/"$efipart"
mkfs.ext4 /dev/"$bootpart"

# Encrypt root partition
cryptsetup luksFormat --type luks2 /dev/"$rootpart"
cryptsetup luksDump /dev/"$rootpart"
blkid
cryptsetup open /dev/"$rootpart" luks-"$partuuid"
