#!/bin/bash

get_partuuid() {
    blkid | grep "crypto_LUKS" | sed -n 's/.*PARTUUID=\"\([^\"]*\)\".*/\1/p'
}

read_partition() {
    local prompt="$1"
    local partition
    read -rp "Enter $prompt partition (e.g. nvme0n1p1): " partition
    echo "$partition"
}

create_btrfs_subvolume() {
    local mount_point="$1"
    local subvol_name="$2"
    btrfs subvolume create "$mount_point/$subvol_name"
}

mount_partition() {
    local source_device="$1"
    local target_mount="$2"
    local subvol_name="$3"
    mount -o subvol="$subvol_name" "$source_device" "$target_mount"
}

partuuid=$(get_partuuid)

efipart=$(read_partition "efi")
bootpart=$(read_partition "boot")

# Create Btrfs filesystem and subvolumes
mkfs.btrfs "/dev/mapper/luks-$partuuid"
mount "/dev/mapper/luks-$partuuid" /mnt

cd /mnt || exit

create_btrfs_subvolume "." "root"
create_btrfs_subvolume "." "var"
create_btrfs_subvolume "." "tmp"
create_btrfs_subvolume "." "home"

# Mount partitions
mkdir /mnt/gentoo
mount_partition "/dev/mapper/luks-$partuuid" "/mnt/gentoo" "root"
mount_partition "/dev/mapper/luks-$partuuid" "/mnt/gentoo/home" "home"
mount_partition "/dev/mapper/luks-$partuuid" "/mnt/gentoo/var" "var"
mount_partition "/dev/mapper/luks-$partuuid" "/mnt/gentoo/tmp" "tmp"

mount "/dev/$bootpart" /mnt/gentoo/boot
mkdir /mnt/gentoo/boot/efi
mount "/dev/$efipart" /mnt/gentoo/boot/efi
