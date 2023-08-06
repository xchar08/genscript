#!/bin/bash

# Read in all volumes
read -p 'Enter device label (e.g., nvme0n1): ' primpart
read -p 'Enter efi partition (e.g., nvme0n1p1): ' efipart
read -p 'Enter boot partition (e.g., nvme0n1p2): ' bootpart
read -p 'Enter root partition (e.g., nvme0n1p3): ' rootpart

# Prompt user for total size in GB
read -p 'Enter total size for partitions (e.g., 100GB): ' totalsize_gb

# Convert total size to MiB
totalsize_mib=$(echo "${totalsize_gb%GB} * 953.674" | bc)

# Create partitions based on calculated sizes
parted -a optimal "/dev/$primpart" -- mklabel gpt
parted -a optimal "/dev/$primpart" -- mkpart ESP fat32 0% 512MiB
parted -a optimal "/dev/$primpart" -- mkpart swap linux-swap 512MiB 8.75GiB
parted -a optimal "/dev/$primpart" -- mkpart rootfs btrfs 8.75GiB "${totalsize_mib}MiB"
parted -a optimal "/dev/$primpart" -- set 1 boot on

# Format partitions
mkfs.fat -F32 "/dev/$efipart"
mkfs.ext4 "/dev/$bootpart"

# Encrypt root partition
cryptsetup luksFormat --type luks2 "/dev/$rootpart"
cryptsetup luksDump "/dev/$rootpart"
blkid

partuuid=$(blkid | grep "crypto_LUKS" | sed -n 's/.*PARTUUID="\([^"]*\)".*/\1/p')

cryptsetup open "/dev/$rootpart" "luks-$partuuid"
