#!/bin/bash

# Read in all volumes
echo -n 'Enter device label (e.g., nvme0n1): '
read -r primpart
echo -n 'Enter efi partition (e.g., nvme0n1p1): '
read -r efipart
echo -n 'Enter boot partition (e.g., nvme0n1p2): '
read -r bootpart
echo -n 'Enter root partition (e.g., nvme0n1p3): '
read -r rootpart

# Prompt user for total size
echo -n 'Enter total size for partitions (e.g., 100G): '
read -r totalsize

# Calculate partition sizes
efi_size="512"
boot_size="1"
swap_size="8.75"
var_size=$(echo "0.13 * $totalsize" | bc)   # 13% of the total size
tmp_size=$(echo "0.06 * $totalsize" | bc)   # 6% of the total size
root_size=$(echo "$totalsize - $efi_size - $boot_size - $swap_size - $var_size - $tmp_size" | bc)

# Create partitions based on calculated sizes
parted -a optimal "/dev/$primpart" -- mklabel gpt
parted -a optimal "/dev/$primpart" -- mkpart ESP fat32 0% "${efi_size}GiB"
parted -a optimal "/dev/$primpart" -- mkpart boot ext4 "${efi_size}GiB" "${boot_size}GiB"
parted -a optimal "/dev/$primpart" -- mkpart swap linux-swap "${boot_size}GiB" +"${swap_size}GiB"
parted -a optimal "/dev/$primpart" -- mkpart rootfs btrfs +"${swap_size}GiB" +"${root_size}GiB"
parted -a optimal "/dev/$primpart" -- mkpart var btrfs +"${root_size}GiB" +"${var_size}GiB"
parted -a optimal "/dev/$primpart" -- mkpart tmp btrfs +"${var_size}GiB" +"${tmp_size}GiB"
parted -a optimal "/dev/$primpart" -- set 1 boot on

# Format partitions
mkfs.fat -F32 "/dev/$efipart"
mkfs.ext4 "/dev/$bootpart"

# Encrypt root partition
cryptsetup luksFormat --type luks2 "/dev/$rootpart"
cryptsetup luksDump "/dev/$rootpart"
blkid

partuuid=$(blkid | grep "crypto_LUKS" | sed -n 's/.*PARTUUID=\"\([^\"]*\)\".*/\1/p')

cryptsetup open "/dev/$rootpart" "luks-$partuuid"
