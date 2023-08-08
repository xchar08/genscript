#!/bin/bash

# Function to read user input
read_input() {
    local prompt="$1"
    read -rp "$prompt" value
    echo "$value"
}

# Function to convert sizes to MiB
convert_to_mib() {
    local input="$1"
    local unit="$2"
    case $unit in
        GB) echo "scale=2; $input * 953.674" | bc ;;
        GiB) echo "$input * 1024" | bc ;;
        MB) echo "scale=2; $input / 0.0009765625" | bc ;;
        MiB) echo "$input" ;;
    esac
}

# Function to create partitions
create_partitions() {
    local device="$1"
    local totalsize_mib="$2"
    
    parted -a optimal "/dev/$device" -- mklabel gpt
    parted -a optimal "/dev/$device" -- mkpart ESP fat32 0% 512MiB
    parted -a optimal "/dev/$device" -- mkpart swap linux-swap 512MiB 8.75GiB
    parted -a optimal "/dev/$device" -- mkpart rootfs btrfs 8.75GiB "${totalsize_mib}MiB"
    parted -a optimal "/dev/$device" -- set 1 boot on
}

# Read in all volumes
primpart=$(read_input "Enter device label (e.g., nvme0n1): ")
efipart=$(read_input "Enter efi partition (e.g., nvme0n1p1): ")
bootpart=$(read_input "Enter boot partition (e.g., nvme0n1p2): ")
rootpart=$(read_input "Enter root partition (e.g., nvme0n1p3): ")

# Prompt user for total size and unit
totalsize_input=$(read_input "Enter total size for partitions (e.g., 100GB, 200GiB, 500MB, 2MiB): ")

# Extract size and unit from input
totalsize=$(echo "$totalsize_input" | grep -oE '[0-9]+')
size_unit=$(echo "$totalsize_input" | grep -oE '[A-Za-z]+')

# Convert total size to MiB
totalsize_mib=$(convert_to_mib "$totalsize" "$size_unit")

# Create partitions based on calculated sizes
create_partitions "$primpart" "$totalsize_mib"

# Format partitions
mkfs.fat -F32 "/dev/$efipart"
mkfs.ext4 "/dev/$bootpart"

# Encrypt root partition
cryptsetup luksFormat --type luks2 "/dev/$rootpart"
cryptsetup luksDump "/dev/$rootpart"
blkid

partuuid=$(blkid | grep "crypto_LUKS" | sed -n 's/.*PARTUUID="\([^"]*\)".*/\1/p')

cryptsetup open "/dev/$rootpart" "luks-$partuuid"
