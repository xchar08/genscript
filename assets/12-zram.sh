#!/bin/bash

# Function to check if a device is busy
function is_device_busy() {
  sudo lsof "$1" >/dev/null 2>&1
}

# Function to unmount zram or loop device if it's in use
function unmount_device() {
  local device="$1"
  local mount_point=$(findmnt -n -o TARGET --source "$device" 2>/dev/null)
  
  if [[ -n "$mount_point" ]]; then
    echo "Unmounting $device from $mount_point..."
    sudo umount "$device"
  fi
  
  if is_device_busy "$device"; then
    echo "Detaching $device..."
    sudo losetup -d "$device"
  fi
}

read -p "Enter the path or device name of the swap partition: " swap_partition

read -p "Do you want to set up regular zram or encrypted zram? (r/e)" choice

case "$choice" in
  r|R )
    # Set up regular zram
    sudo modprobe zram
    
    # Unmount and detach zram0 if it's in use
    unmount_device "/dev/zram0"
    echo $((6144*1024*1024)) | sudo tee /sys/block/zram0/disksize > /dev/null
    
    sudo mkswap /dev/zram0
    sudo swapon /dev/zram0 -p 10
    
    sudo bash -c 'cat << EOF > /etc/local.d/zram.start
#!/bin/sh
modprobe zram
echo $((6144*1024*1024)) > /sys/block/zram0/disksize
mkswap /dev/zram0
swapon /dev/zram0 -p 10
EOF'

    sudo bash -c 'cat << EOF > /etc/local.d/zram.stop
#!/bin/sh
swapoff /dev/zram0
echo 1 > /sys/block/zram0/reset
echo 0 > /sys/block/zram0/disksize
modprobe -r zram
EOF'
    
    sudo chmod +x /etc/local.d/zram.start
    sudo chmod +x /etc/local.d/zram.stop
    
    sudo rc-update add local default
    ;;
  e|E )
    # Generate a random passphrase for encryption
    passphrase=$(sudo openssl rand -hex 32)
    
    # Update /etc/crypttab
    sudo bash -c "echo 'swap      $swap_partition    /dev/urandom   swap,cipher=aes-xts-plain64,size=8192' >> /etc/crypttab"
    
    # Update /etc/fstab
    sudo bash -c "echo '/dev/mapper/swap  none   swap    defaults   0       0' >> /etc/fstab"
    
    # Enable encrypted swap on boot
    sudo rc-update add swap boot
    
    # Set the passphrase for the swap partition
    sudo bash -c "echo 'swap_crypt UUID=$(sudo blkid -s UUID -o value $swap_partition) none luks,keyscript=decrypt_keyctl' > /etc/conf.d/dmcrypt_swap_passphrase"
    sudo bash -c "echo 'passphrase=$passphrase' >> /etc/conf.d/dmcrypt_swap_passphrase"
    
    # Set the correct permissions for the passphrase file
    sudo chmod 0600 /etc/conf.d/dmcrypt_swap_passphrase
    
    # Update the initramfs
    sudo dracut --force --regenerate-all
    ;;
esac
echo "Reboot your computer..."