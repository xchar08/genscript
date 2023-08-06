#!/bin/bash

# Set the timezone
read -rp "Select timezone (e.g. America/Chicago): " timezone
echo "${timezone}" > /etc/timezone
emerge --config sys-libs/timezone-data --autounmask{,-write,-continue}

# Generate the locale
nano -w /etc/locale.gen
locale-gen
eselect locale list
read -rp "Select locale (e.g. 1): " locale
eselect locale set "$locale"
env-update && source /etc/profile

# Generate fstab
emerge sys-fs/genfstab --autounmask{,-write,-continue}
genfstab -U / > /etc/fstab
