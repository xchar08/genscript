#!/bin/bash

read -p "Enter your username: " us
read -p "Enter the URL: " whonixlink

echo "The URL you entered is: $whonixlink"

sudo virsh -c qemu:///system net-autostart default
sudo virsh -c qemu:///system net-start default
mkdir -p /home/"$us"/Whonix
cd /home/"$us"/Whonix
wget -O /home/"$us"/Whonix/"$whonixlink" $whonixlink

tar -xvf /home/"$us"/Whonix/Whonix*.libvirt.xz

touch /home/"$us"/Whonix/WHONIX_BINARY_LICENSE_AGREEMENT_accepted

# Add the virtual networks
sudo virsh -c qemu:///system net-define /home/"$us"/Whonix/Whonix_external*.xml
sudo virsh -c qemu:///system net-define /home/"$us"/Whonix/Whonix_internal*.xml

# Activate the virtual networks. 
sudo virsh -c qemu:///system net-autostart Whonix-External
sudo virsh -c qemu:///system net-start Whonix-External
sudo virsh -c qemu:///system net-autostart Whonix-Internal
sudo virsh -c qemu:///system net-start Whonix-Internal

# Import the Whonix ™ Gateway and Workstation images.
sudo virsh -c qemu:///system define /home/"$us"/Whonix/Whonix-Gateway*.xml
sudo virsh -c qemu:///system define /home/"$us"/Whonix/Whonix-Workstation*.xml

# Moving Whonix ™ Image Files
sudo mkdir -p /var/lib/libvirt/images/
sudo mv Whonix-Gateway*.qcow2 /var/lib/libvirt/images/Whonix-Gateway.qcow2
sudo mv Whonix-Workstation*.qcow2 /var/lib/libvirt/images/Whonix-Workstation.qcow2

# Encrypt container
#sudo chmod og+xr /run/media/private/user/$container_name
#sudo sed -i '0,/"",/s//"/run/media/private/user/Whonix-Gateway.qcow2"/' /run/media/private/user/$container_name

# Cleanup

rm Whonix*
rm -r WHONIX*
cd /home/"$us"
rm -rf Whonix
 
echo 'Follow these steps for a bit more info: https://yewtu.be/watch?v=-dWEcBQZBXw'
echo 'See the wiki for more info: https://www.whonix.org/wiki/Post_Install_Advice'
