#!/bin/bash

set -e

# Source the system profile
source /etc/profile

# Set the chroot prompt
export PS1="(chroot) $PS1"

# Sync the portage tree
emerge-webrsync

# Select the profile
eselect profile list
read -rp "Select profile (e.g. 1): " profile
eselect profile set "$profile"

# Enable required USE flags
emerge --ask app-portage/flaggie --ask-new-use
flaggie sys-kernel/installkernel-gentoo +grub
emerge --ask app-shells/bash-completion --ask-new-use
emerge --ask app-portage/gentoolkit --ask-new-use
emerge --ask app-portage/eix --ask-new-use

# Set the timezone
read -rp "Select timezone (e.g. America/Eastern): " timezone
echo "${timezone}" > /etc/timezone
emerge --config sys-libs/timezone-data --ask-new-use

# Generate the locale
nano -w /etc/locale.gen
locale-gen
eselect locale list
read -rp "Select locale (e.g. 1): " locale
eselect locale set "$locale"
env-update && source /etc/profile

# Generate fstab
emerge --ask sys-fs/genfstab --ask-new-use
genfstab -U / > /etc/fstab

# Install required packages
emerge --ask sys-kernel/linux-firmware --ask-new-use
emerge --ask sys-fs/btrfs-progs --ask-new-use
emerge --ask sys-apps/pciutils --ask-new-use
emerge --ask sys-apps/lm-sensors --ask-new-use
rc-update add lm_sensors default
rc-service lm_sensors start
rc-update add elogind boot
euse -E networkmanager
emerge --ask sys-kernel/gentoo-kernel-bin --ask-new-use
emerge sys-fs/cryptsetup --ask-new-use
emerge --config gentoo-kernel-bin --ask-new-use
echo 'sys-boot/grub:2 device-mapper' >> /etc/portage/package.use/sys-boot
emerge -a sys-boot/os-prober --ask-new-use
emerge -av grub --ask-new-use

# Configure GRUB
partuuid=$(blkid | grep "crypto_LUKS" | sed -n 's/.*PARTUUID=\"\([^\"]*\)\".*/\1/p')

echo 'GRUB_CMDLINE_LINUX="rd.luks.partuuid='$partuuid'"
GRUB_TIMEOUT_STYLE=hidden
GRUB_GFXPAYLOAD_LINUX="keep"
GRUB_THEME="/boot/grub/themes/catppuccin-mocha-grub-theme/theme.txt"
GRUB_DISABLE_LINUX_UUID=false
GRUB_DISABLE_LINUX_PARTUUID=true
GRUB_DISABLE_OS_PROBER=false' | sudo tee -a /etc/default/grub

#install grub to proper location

grub-install --target=x86_64-efi --efi-directory=/boot/efi
grub-mkconfig -o /boot/grub/grub.cfg
passwd
emerge --ask app-editors/neovim --ask-new-use
emerge -auDN world
emerge --depclean
