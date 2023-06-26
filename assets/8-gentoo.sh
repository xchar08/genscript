#!/bin/bash

touch /etc/portage/package.use~
cat /etc/portage/package.use/sys-boot >> /etc/portage/package.use~
cat /etc/portage/package.use/99local.conf >> /etc/portage/package.use~
rm -rf /etc/portage/package.use/
mv /etc/portage/package.use~ /etc/portage/package.use
cat /root/gentoo-secured-dwl/assets/package.use >> /etc/portage/package.use

passwd

emerge -auDN world
dispatch-conf
emerge -auDN world
emerge --depclean

emerge net-wireless/networkmanager
rc-service networkmanager start
rc-update add networkmanager default

echo "Reboot your computer..."
