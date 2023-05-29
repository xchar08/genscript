#!/bin/bash

#create user and configure sudo

emerge app-admin/sudo --autounmask{,-write,-continue}

echo "Please enter the username you would like to create in Gentoo:"
read -r us
usermod -aG wheel,video,audio,user,portage "$us"
echo "$us" | sudo tee /etc/hostname
echo "%wheel ALL=(ALL:ALL) ALL" | sudo tee -a /etc/sudoers
echo -e "Defaults rootpw\nDefaults !tty_tickets" | sudo tee -a /etc/sudoers


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
emerge x11-drivers/nvidia-drivers --autounmask{,-write,-continue}
emerge sys-firmware/nvidia-firmware --autounmask{,-write,-continue}
modprobe nvidia
fi

#utility
emerge x11-misc/wmname --autounmask{,-write,-continue}
emerge sys-fs/ntfs3g --autounmask{,-write,-continue}
emerge sys-apps/usbutils --autounmask{,-write,-continue}
emerge app-portage/eix --autounmask{,-write,-continue}

#fonts
emerge media-fonts/source-pro --autounmask{,-write,-continue}
emerge media-fonts/noto-emoji --autounmask{,-write,-continue}
emerge media-fonts/noto --autounmask{,-write,-continue}

#terminal
echo -n "Select terminal (alacritty, kitty, xterm): "
read -r term
case "$term" in
"alacritty") emerge x11-terms/alacritty --autounmask{,-write,-continue} ;;
"kitty") emerge x11-terms/kitty --autounmask{,-write,-continue} ;;
"xterm") emerge x11-terms/xterm --autounmask{,-write,-continue} ;;
esac

#setting up ram

# Function to check if a device is busy
function is_device_busy() {
  lsof "$1" >/dev/null 2>&1
}

# Function to unmount zram or loop device if it's in use
function unmount_device() {
  local device="$1"
  local mount_point=$(findmnt -n -o TARGET --source "$device" 2>/dev/null)
  
  if [[ -n "$mount_point" ]]; then
    echo "Unmounting $device from $mount_point..."
    umount "$device"
  fi
  
  if is_device_busy "$device"; then
    echo "Detaching $device..."
    losetup -d "$device"
  fi
}

#!/bin/bash

# Function to check if a device is busy
function is_device_busy() {
  lsof "$1" >/dev/null 2>&1
}

# Function to unmount zram or loop device if it's in use
function unmount_device() {
  local device="$1"
  local mount_point=$(findmnt -n -o TARGET --source "$device" 2>/dev/null)
  
  if [[ -n "$mount_point" ]]; then
    echo "Unmounting $device from $mount_point..."
    umount "$device"
  fi
  
  if is_device_busy "$device"; then
    echo "Detaching $device..."
    losetup -d "$device"
  fi
}

read -p "Do you want to set up regular zram or encrypted zram? (r/e)" choice

case "$choice" in
  r|R )
    # Set up regular zram
    modprobe zram
    
    # Unmount and detach zram0 if it's in use
    unmount_device "/dev/zram0"
    echo $((6144*1024*1024)) > /sys/block/zram0/disksize
    
    mkswap /dev/zram0
    swapon /dev/zram0 -p 10
    
    cat << EOF > /etc/local.d/zram.start
#!/bin/sh
modprobe zram
echo $((6144*1024*1024)) > /sys/block/zram0/disksize
mkswap /dev/zram0
swapon /dev/zram0 -p 10
EOF

    cat << EOF > /etc/local.d/zram.stop
#!/bin/sh
swapoff /dev/zram0
echo 1 > /sys/block/zram0/reset
echo 0 > /sys/block/zram0/disksize
modprobe -r zram
EOF
    
    chmod +x /etc/local.d/zram.start
    chmod +x /etc/local.d/zram.stop
    
    rc-update add local default
    ;;
  e|E )
    # Set up encrypted zram
    modprobe zram
    
    # Unmount and detach zram0 and loop0 if they are in use
    unmount_device "/dev/zram0"
    unmount_device "/dev/loop0"
    
    echo $((6144*1024*1024)) > /sys/block/zram0/disksize

    losetup /dev/loop0 /dev/zram0
    
    # Check if /dev/loop0 is already in use
    if is_device_busy "/dev/loop0"; then
      echo "Error: /dev/loop0 is already in use. Exiting..."
      losetup -d /dev/loop0
      exit 1
    fi

    if cryptsetup isLuks /dev/loop0; then
      cryptsetup open /dev/loop0 zram0_crypt
      mkswap /dev/mapper/zram0_crypt
      swapon /dev/mapper/zram0_crypt -p 10
    else
      echo "Creating LUKS container on /dev/loop0..."
      cryptsetup -c aes-xts-plain64 -s 256 luksFormat /dev/loop0
      cryptsetup open /dev/loop0 zram0_crypt
      mkswap /dev/mapper/zram0_crypt
      swapon /dev/mapper/zram0_crypt -p 10
    fi

    cat << EOF > /etc/local.d/zram.start
#!/bin/sh
modprobe zram
echo $((6144*1024*1024)) > /sys/block/zram0/disksize
losetup /dev/loop0 /dev/zram0
if cryptsetup isLuks /dev/loop0; then
  cryptsetup open /dev/loop0 zram0_crypt
  mkswap /dev/mapper/zram0_crypt
  swapon /dev/mapper/zram0_crypt -p 10
fi
EOF

    cat << EOF > /etc/local.d/zram.stop
#!/bin/sh
swapoff /dev/mapper/zram0_crypt
cryptsetup close zram0_crypt
losetup -d /dev/loop0
echo 1 > /sys/block/zram0/reset
echo 0 > /sys/block/zram0/disksize
modprobe -r zram
EOF

    chmod +x /etc/local.d/zram.start
    chmod +x /etc/local.d/zram.stop

    rc-update add local default
    ;;
  * )
    echo "Invalid choice. Exiting..."
    ;;
esac
