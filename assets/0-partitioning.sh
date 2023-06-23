#!/bin/bash

# Read in all volumes
read -p 'Enter device label (e.g., nvme0n1): ' primpart
read -p 'Enter efi partition (e.g., nvme0n1p1): ' efipart
read -p 'Enter boot partition (e.g., nvme0n1p2): ' bootpart
read -p 'Enter root partition (e.g., nvme0n1p3): ' rootpart

# Prompt user for total size in GB
read -p 'Enter total size for partitions (e.g., 100G): ' totalsize_gb

# Convert total size to MiB
totalsize_mib=$(echo "$totalsize_gb * 953.674" | bc)

# Calculate partition sizes
efi_size="512MiB"
boot_size="1GiB"
swap_size="8.75GiB"
var_size=$(echo "0.13 * $totalsize_mib" | bc)   # 13% of the total size
tmp_size=$(echo "0.06 * $totalsize_mib" | bc)   # 6% of the total size
root_size=$(echo "$totalsize_mib - ${efi_size%MiB} - (${boot_size%GiB} * 1024) - (${swap_size%GiB} * 1024) - $var_size - $tmp_size" | bc)

# Create partitions based on calculated sizes
parted -a optimal "/dev/$primpart" mklabel gpt
parted -a optimal "/dev/$primpart" mkpart ESP fat32 0% "${efi_size}MiB"
parted -a optimal "/dev/$primpart" mkpart boot ext4 "${efi_size}MiB ${boot_size}MiB"
parted -a optimal "/dev/$primpart" mkpart swap linux-swap "${boot_size}MiB ${swap_size}MiB"
parted -a optimal "/dev/$primpart" mkpart rootfs btrfs "${swap_size}MiB ${root_size}MiB"
parted -a optimal "/dev/$primpart" mkpart var btrfs "${root_size}MiB ${var_size}MiB"
parted -a optimal "/dev/$primpart" mkpart tmp btrfs "${var_size}MiB ${tmp_size}MiB"
parted -a optimal "/dev/$primpart" set 2 boot on

# Format partitions
mkfs.fat -F32 "/dev/$efipart"
mkfs.ext4 "/dev/$bootpart"

# Encrypt root partition
cryptsetup luksFormat --type luks2 "/dev/$rootpart"
cryptsetup luksDump "/dev/$rootpart"
blkid

partuuid=$(blkid | grep "crypto_LUKS" | sed -n 's/.*PARTUUID="\([^"]*\)".*/\1/p')

cryptsetup open "/dev/$rootpart" "luks-$partuuid"
