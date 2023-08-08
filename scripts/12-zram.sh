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

# Ask the user for the desired size
read -rp "Enter the size for zram0 (e.g., 6 GiB, 6144 MB, or 6 MiB): " size_input

# Parse user input to get the size in bytes
size_bytes=0
if echo "$size_input" | grep -qi ' GiB'; then
    size_input=$(echo "$size_input" | sed 's/ GiB//')
    size_bytes=$((size_input * 1024 * 1024 * 1024))
elif echo "$size_input" | grep -qi ' GB'; then
    size_input=$(echo "$size_input" | sed 's/ GB//')
    size_bytes=$((size_input * 1000 * 1000 * 1000))
elif echo "$size_input" | grep -qi ' MiB'; then
    size_input=$(echo "$size_input" | sed 's/ MiB//')
    size_bytes=$((size_input * 1024 * 1024))
elif echo "$size_input" | grep -qi ' MB'; then
    size_input=$(echo "$size_input" | sed 's/ MB//')
    size_bytes=$((size_input * 1000 * 1000))
fi

# Set up regular zram
sudo modprobe zram

# Unmount and detach zram0 if it's in use
unmount_device "/dev/zram0"
echo "$size_bytes" | sudo tee /sys/block/zram0/disksize > /dev/null

sudo mkswap /dev/zram0
sudo swapon /dev/zram0 -p 10

sudo bash -c 'cat << EOF > /etc/local.d/zram.start
#!/bin/sh
modprobe zram
echo $size_bytes > /sys/block/zram0/disksize
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

echo "Reboot your computer..."
