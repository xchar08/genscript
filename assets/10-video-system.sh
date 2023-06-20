#!/bin/bash

if lspci | grep -i VGA | grep -c Intel > 0
then
    emerge sys-firmware/intel-microcode --autounmask{,-write,-continue}
    emerge x11-drivers/xf86-video-intel --autounmask{,-write,-continue}
fi

if lspci -nnkv | sed -n '/Network/,/^$/p' | grep -c iwlwifi > 0
then
    modprobe iwlwifi
fi

if lspci | grep -c nvidia > 0
then
    read -p "Nvidia or Noveau: " input

    emerge sys-firmware/nvidia-firmware --autounmask{,-write,-continue}

    if [ "$input" = "nvidia" ]; then
        emerge x11-drivers/nvidia-drivers --autounmask{,-write,-continue}
        modprobe nvidia
    if [ "$input" = "nvidia" ]; then
        emerge x11-drivers/xf86-video-nouveau --autounmask{,-write,-continue}
        modprobe nouveau
    else
        echo "Please enter a valid option"
    fi
fi

if lspci | grep -i VGA | grep -c AMD > 0; then
    emerge x11-drivers/xf86-video-amdgpu --autounmask{,-write,-continue}
    modprobe amdgpu
fi

if lspci -nnkv | sed -n '/Network/,/^$/p' | grep -c "Atheros\|Qualcomm" > 0; then
    modprobe ath9k
fi

#utility
emerge x11-misc/wmname --autounmask{,-write,-continue}
emerge sys-fs/ntfs3g --autounmask{,-write,-continue}
emerge sys-apps/usbutils --autounmask{,-write,-continue}
emerge app-portage/eix --autounmask{,-write,-continue}