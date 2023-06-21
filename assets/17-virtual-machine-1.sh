#!/bin/bash

#Virt-manager

if ! grep -q "QEMU_SOFTMMU_TARGETS=\"arm x86_64 sparc\"" /etc/portage/make.conf; then
    echo 'QEMU_SOFTMMU_TARGETS="arm x86_64 sparc"' | sudo tee -a /etc/portage/make.conf > /dev/null
fi

if ! grep -q "QEMU_USER_TARGETS=\"x86_64\"" /etc/portage/make.conf; then
    echo 'QEMU_USER_TARGETS="x86_64"' | sudo tee -a /etc/portage/make.conf > /dev/null
fi

sudo emerge --ask virt-manager qemu xf86-video-qxl app-emulation/spice spice-gtk spice-protocol net-firewall/iptables
sudo dispatch-conf
sudo emerge --ask virt-manager qemu xf86-video-qxl app-emulation/spice spice-gtk spice-protocol net-firewall/iptables

sudo groupadd kvm
sudo groupadd libvirt

sudo usermod -aG kvm "$USER"
sudo usermod -aG libvirt "$USER"

sudo /etc/init.d/libvirtd start
sudo rc-update add libvirtd default

if [ ! -d /etc/polkit-1/localauthority/50-local.d ]; then
    sudo mkdir -p /etc/polkit-1/localauthority/50-local.d
fi

echo '[Allow group libvirt management permissions]
Identity=unix-group:libvirt
Action=org.libvirt.unix.manage
ResultAny=yes
ResultInactive=yes
ResultActive=yes' | sudo tee /etc/polkit-1/localauthority/50-local.d/org.libvirt.unix.manage.pkla > /dev/null

sudo modprobe kvm kvm-intel tun

echo 'modules="kvm tun kvm-intel"' | sudo tee -a /etc/conf.d/modules > /dev/null

echo "Reboot your computer..."