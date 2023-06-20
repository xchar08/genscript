#!/bin/bash

# Configure GRUB
partuuid=$(blkid | grep "crypto_LUKS" | sed -n 's/.*PARTUUID=\"\([^\"]*\)\".*/\1/p')

#install GRUB to proper location

grub-install --target=x86_64-efi --efi-directory=/boot/efi

echo 'GRUB_CMDLINE_LINUX="rd.luks.partuuid='$partuuid'"
GRUB_TIMEOUT_STYLE=hidden
GRUB_GFXPAYLOAD_LINUX="keep"
GRUB_THEME="/boot/grub/themes/catppuccin-mocha-grub-theme/theme.txt"
GRUB_DISABLE_LINUX_UUID=false
GRUB_DISABLE_LINUX_PARTUUID=true
GRUB_DISABLE_OS_PROBER=false' >> /etc/default/grub

sed -i '0,/^GRUB_DISABLE_LINUX_PARTUUID=false/{s/^GRUB_DISABLE_LINUX_PARTUUID=false/#&/}' /etc/default/grub

grub-mkconfig -o /boot/grub/grub.cfg