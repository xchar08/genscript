#!/bin/bash

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
   
    # Generate a random passphrase for encryption
    passphrase=$(sudo openssl rand -hex 32)
    
    # Update /etc/crypttab
    echo "swap      <device>    /dev/urandom   swap,cipher=aes-xts-plain64,size=8192" | sudo tee -a /etc/crypttab > /dev/null
    
    # Replace <device> with the actual device name or path for your swap partition
    
    # Update /etc/fstab
    echo "/dev/mapper/swap  none   swap    defaults   0       0" | sudo tee -a /etc/fstab > /dev/null
    
    # Enable encrypted swap on boot
    sudo rc-update add swap boot
    
    # Set the passphrase for the swap partition
    echo "swap_crypt UUID=$(sudo blkid -s UUID -o value <device>) none luks,keyscript=decrypt_keyctl" | sudo tee /etc/conf.d/dmcrypt_swap_passphrase > /dev/null
    echo "passphrase=$passphrase" | sudo tee -a /etc/conf.d/dmcrypt_swap_passphrase > /dev/null
    
    # Set the correct permissions for the passphrase file
    sudo chmod 0600 /etc/conf.d/dmcrypt_swap_passphrase
    
    # Update the initramfs
    sudo dracut --force --regenerate-all
    ;;
esac
