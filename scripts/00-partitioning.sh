#!/bin/bash

# Read in all volumes
read -p 'Enter device label (e.g., nvme0n1): ' primpart
read -p 'Enter efi partition (e.g., nvme0n1p1): ' efipart
read -p 'Enter boot partition (e.g., nvme0n1p2): ' bootpart
read -p 'Enter root partition (e.g., nvme0n1p3): ' rootpart

# Function to convert sizes to MiB
convert_to_mib() {
    input=$1
    unit=$2

    case $unit in
        GB) echo "${input} * 953.674" | bc ;;
        GiB) echo "${input} * 1024" | bc ;;
        MB) echo "${input} / 0.0009765625" | bc ;;
        MiB) echo "${input}" ;;
    esac
}

# Prompt user for total size and unit
read -p 'Enter total size for partitions (e.g., 100GB, 200GiB, 500MB, 2MiB): ' totalsize_input

# Extract size and unit from input
totalsize=$(echo $totalsize_input | grep -oE '[0-9]+')
size_unit=$(echo $totalsize_input | grep -oE '[A-Za-z]+')

# Convert total size to MiB
totalsize_mib=$(convert_to_mib $totalsize $size_unit)

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
