if [lspci | grep -i VGA | grep -c Intel -gt 0]
then
    emerge --ask sys-firmware/intel-microcode --autounmask{,-write,-continue}
    emerge --ask x11-drivers/xf86-video-intel --autounmask{,-write,-continue}
fi

if [lspci -nnkv | sed -n '/Network/,/^$/p' | grep -c iwlwifi -gt 0]
then
    modprobe iwlwifi
fi

if [lspci | grep -c nvidia -gt 0]
then
    emerge --ask  x11-drivers/nvidia-drivers --autounmask{,-write,-continue}
    emerge --ask sys-firmware/nvidia-firmware --autounmask{,-write,-continue}
fi

#utility
emerge --ask x11-misc/wmname --autounmask{,-write,-continue}
emerge --ask sys-fs/ntfs3g --autounmask{,-write,-continue}
emerge --ask sys-apps/usbutils --autounmask{,-write,-continue}
emerge --ask app-portage/eix --autounmask{,-write,-continue}

#fonts
emerge --ask media-fonts/source-pro --autounmask{,-write,-continue}
emerge --ask media-fonts/noto --autounmask{,-write,-continue}
emerge --ask media-fonts/noto-emoji --autounmask{,-write,-continue}

#terminal
emerge --ask x11-terms/alacritty --autounmask{,-write,-continue}

#desktop env
emerge --ask kde-plasma/plasma-meta --autounmask{,-write,-continue} #kde
emerge --ask kde-apps/kwalletmanager --autounmask{,-write,-continue}
emerge --ask kde-plasma/kwallet-pam --autounmask{,-write,-continue}

#X11 : ~/.xinitrc
#!/bin/sh
exec dbus-launch --exit-with-session startplasma-x11

#Wayland : ~/.profile
#!/bin/sh
dbus-launch --exit-with-session startplasma-wayland

emerge --ask kde-plasma/kdeplasma-addons #widgets

emerge --ask gnome-base/gnome --autounmask{,-write,-continue} #gnome
#/etc/conf.d/display-manager
DISPLAYMANAGER="gdm"

#X11
echo "exec gnome-session" > ~/.xinitrc
sed -i '1i\export XDG_MENU_PREFIX=gnome-' ~/.xinitrc

emerge --ask gnome-extra/gnome-shell-extensions #extensions

##for later: add these to make.conf 
#USE="-qt5 -kde X gtk gnome systemd"

#!!!!

emerge --ask --noreplace gui-libs/display-manager-init --autounmask{,-write,-continue}
rc-update add display-manager default 
rc-service display-manager start 