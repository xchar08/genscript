#!/bin/bash

# Enable required USE flags
emerge app-portage/flaggie --autounmask{,-write,-continue}
flaggie sys-kernel/installkernel-gentoo +grub
emerge app-shells/bash-completion --autounmask{,-write,-continue}
emerge app-portage/gentoolkit --autounmask{,-write,-continue}
emerge app-portage/eix --autounmask{,-write,-continue}

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
emerge app-editors/neovim --autounmask{,-write,-continue}
emerge --ask dev-vcs/git --autounmask{,-write,-continue}
