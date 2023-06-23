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

# Calculate partition start and end points
efi_start=0
efi_end="${efi_size}"
boot_start="${efi_end}"
boot_end=$(echo "${boot_start} + ${boot_size}" | bc)
swap_start="${boot_end}"
swap_end=$(echo "${swap_start} + ${swap_size}" | bc)
root_start="${swap_end}"
root_end=$(echo "${root_start} + ${root_size}" | bc)
var_start="${root_end}"
var_end=$(echo "${var_start} + ${var_size}" | bc)
tmp_start="${var_end}"
#tmp_end=$(echo "${tmp_start} + ${tmp_size}" | bc)
tmp_end="${totalsize_mib}"

# Create partitions based on calculated sizes
parted -a optimal "/dev/$primpart" mklabel gpt
parted -a optimal "/dev/$primpart" mkpart ESP fat32 "${efi_start}MiB" "${efi_end}MiB"
parted -a optimal "/dev/$primpart" mkpart boot ext4 "${boot_start}MiB" "${boot_end}MiB"
parted -a optimal "/dev/$primpart" mkpart swap linux-swap "${swap_start}MiB" "${swap_end}MiB"
parted -a optimal "/dev/$primpart" mkpart rootfs btrfs "${root_start}MiB" "${root_end}MiB"
parted -a optimal "/dev/$primpart" mkpart var btrfs "${var_start}MiB" "${var_end}MiB"
parted -a optimal "/dev/$primpart" mkpart tmp btrfs "${tmp_start}MiB" "${tmp_end}MiB"
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
