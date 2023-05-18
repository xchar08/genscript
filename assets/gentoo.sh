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

#create the makefile
echo 'COMMON_FLAGS="-O2 -march=native -pipe"
CFLAGS="${COMMON_FLAGS}"
CXXFLAGS="${COMMON_FLAGS}"
FCFLAGS="${COMMON_FLAGS}"
FFLAGS="${COMMON_FLAGS}"
MAKEOPTS="-j8"
ACCEPT_KEYWORDS="~amd64"
ACCEPT_LICENSE="*"' | tee /etc/portage/make.conf
echo -n "Enter the video cards string: (ex. nvidia intel i915)"
read video_cards
echo 'VIDEO_CARDS="'$video_cards'"' | tee -a /etc/portage/make.conf
echo -n "Enter the USE flags: (ex. -ldap acl alsa bluetooth chroot cryptsetup cups dbus elogind gecko -kde man pulseaudio secure_delete strict -systemd valgrind vulkan webrsync-gpg wifi X xinerama networkmanager)"
read use_flags
echo 'USE="'$use_flags'"' | tee -a /etc/portage/make.conf
echo 'PORTDIR="/var/db/repos/gentoo"
DISTDIR="/var/cache/distfiles"
PKGDIR="/var/cache/binpkgs"
# This sets the language of build output to English.
# Please keep this setting intact when reporting bugs.
LC_MESSAGES=C
GENTOO_MIRRORS="https://mirror.leaseweb.com/gentoo/ http://mirror.leaseweb.com/gentoo/ rsync://mirror.leaseweb.com/gentoo/"' | tee /etc/portage/make.conf


# Enable required USE flags
emerge app-portage/flaggie --autounmask{,-write,-continue}
flaggie sys-kernel/installkernel-gentoo +grub
emerge app-shells/bash-completion --autounmask{,-write,-continue}
emerge app-portage/gentoolkit --autounmask{,-write,-continue}
emerge app-portage/eix --autounmask{,-write,-continue}

# Set the timezone
read -rp "Select timezone (e.g. America/Eastern): " timezone
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

# Install required packages
emerge sys-kernel/linux-firmware --autounmask{,-write,-continue}
emerge sys-fs/btrfs-progs --autounmask{,-write,-continue}
emerge sys-apps/pciutils --autounmask{,-write,-continue}
emerge sys-apps/lm-sensors --autounmask{,-write,-continue}
rc-update add lm_sensors default
rc-service lm_sensors start
rc-update add elogind boot
euse -E networkmanager
emerge sys-kernel/gentoo-kernel-bin --autounmask{,-write,-continue}
emerge sys-fs/cryptsetup --autounmask{,-write,-continue}
emerge --config gentoo-kernel-bin --autounmask{,-write,-continue}
echo 'sys-boot/grub:2 device-mapper' >> /etc/portage/package.use/sys-boot
emerge -a sys-boot/os-prober --autounmask{,-write,-continue}
emerge -av grub --autounmask{,-write,-continue}

# Configure GRUB
partuuid=$(blkid | grep "crypto_LUKS" | sed -n 's/.*PARTUUID=\"\([^\"]*\)\".*/\1/p')

echo 'GRUB_CMDLINE_LINUX="rd.luks.partuuid='$partuuid'"
GRUB_TIMEOUT_STYLE=hidden
GRUB_GFXPAYLOAD_LINUX="keep"
GRUB_THEME="/boot/grub/themes/catppuccin-mocha-grub-theme/theme.txt"
GRUB_DISABLE_LINUX_UUID=false
GRUB_DISABLE_LINUX_PARTUUID=true
GRUB_DISABLE_OS_PROBER=false' | sudo tee -a /etc/default/grub

#install GRUB to proper location

grub-install --target=x86_64-efi --efi-directory=/boot/efi
grub-mkconfig -o /boot/grub/grub.cfg
passwd
emerge app-editors/neovim --autounmask{,-write,-continue}
emerge -auDN world
emerge --depclean

echo "Reboot your computer."
