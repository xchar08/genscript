#!/bin/bash

sudo virsh -c qemu:///system net-autostart default
sudo virsh -c qemu:///system net-start default

#!/bin/bash

read -p "Enter the URL: " whonixlink

echo "The URL you entered is: $whonixlink"

mkdir ~/Whonix
cd ~/Whonix
wget $whonixlink

tar -xvf Whonix*.libvirt.xz

touch WHONIX_BINARY_LICENSE_AGREEMENT_accepted

# Add the virtual networks
sudo virsh -c qemu:///system net-define Whonix_external*.xml
sudo virsh -c qemu:///system net-define Whonix_internal*.xml

# Activate the virtual networks. 
sudo virsh -c qemu:///system net-autostart Whonix-External
sudo virsh -c qemu:///system net-start Whonix-External
sudo virsh -c qemu:///system net-autostart Whonix-Internal
sudo virsh -c qemu:///system net-start Whonix-Internal

# Import the Whonix ™ Gateway and Workstation images.
sudo virsh -c qemu:///system define Whonix-Gateway*.xml
sudo virsh -c qemu:///system define Whonix-Workstation*.xml

# Moving Whonix ™ Image Files
sudo mv Whonix-Gateway*.qcow2 /var/lib/libvirt/images/Whonix-Gateway.qcow2
sudo mv Whonix-Workstation*.qcow2 /var/lib/libvirt/images/Whonix-Workstation.qcow2

# Encrypt container
sudo chmod og+xr /run/media/private/user/$container_name
sudo sed -i '0,/"",/s//"/run/media/private/user/Whonix-Gateway.qcow2"/' /run/media/private/user/$container_name

# Cleanup

rm Whonix*
rm -r WHONIX*
 
echo 'Follow these steps for a bit more info: https://yewtu.be/watch?v=-dWEcBQZBXw'
echo 'See the wiki for more info: https://www.whonix.org/wiki/Post_Install_Advice'
