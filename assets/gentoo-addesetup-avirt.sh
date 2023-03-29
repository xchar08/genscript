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

# security patches

#antivirus
sudo emerge app-antivirus/clamav --autounmask{,-write,-continue}
sudo freshclam
sudo rc-service freshclam start 
sudo rc-service clamd start 
sudo rc-update add clamd default 
sudo emerge app-antivirus/clamtk --autounmask{,-write,-continue}

#password manager
sudo emerge app-admin/keepassxc --autounmask{,-write,-continue}

#ssh
sudo emerge net-misc/sshrc --autounmask{,-write,-continue}

#ssh hardening 
sudo sh -c 'echo "PermitRootLogin no" >> /etc/ssh/sshd_config'
sudo sh -c 'echo "AllowUsers $(whoami)" >> /etc/ssh/sshd_config'

#mac changer
sudo emerge net-analyzer/macchanger --autounmask{,-write,-continue}

sudo touch /etc/local.d/macchanger.start
sudo touch /etc/local.d/macchanger.stop
echo -e '#!/bin/bash\nmacchanger -r $(ip a | grep enp | awk '\''{print $2}'\'' | tr -d :)' | sudo tee /etc/local.d/macchanger.start >/dev/null && sudo chmod +x /etc/local.d/macchanger.start
echo -e '#!/bin/bash\nkillall macchanger' | sudo tee /etc/local.d/macchanger.stop >/dev/null && sudo chmod +x /etc/local.d/macchanger.stop
sudo rc-update add local default 

#super strict ufw
sudo ufw limit 22/tcp
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw enable

#fail2ban
sudo emerge net-analyzer/fail2ban --autounmask{,-write,-continue}
sudo emerge dev-python/pyinotify --autounmask{,-write,-continue}

sudo sed -i 's/enabled = false/enabled = true/g' /etc/fail2ban/jail.conf
sudo cp /etc/fail2ban/jail.conf /etc/fail2ban/jail.local
sudo mv filter.d/ jail.d/

sudo rc-update add fail2ban default
sudo rc-service fail2ban start

sudo emerge sys-process/audit --autounmask{,-write,-continue}
sudo rc-update add auditd default
sudo rc-service auditd start


#thunderbird

sudo emerge mail-client/thunderbird --autounmask{,-write,-continue}
xdg-mime default thunderbird.desktop x-scheme-handler/mailto

#klogd

sudo emerge app-admin/sysklogd --autounmask{,-write,-continue}
sudo dispatch-conf
sudo emerge app-admin/sysklogd --autounmask{,-write,-continue}
sudo rc-update add sysklogd default

sudo wget https://raw.githubusercontent.com/jpx32/dotfiles-space/main/etc/syslog.conf -O /etc/syslog.conf
sudo bash -c 'echo -e "# Config file for /etc/init.d/sysklogd\n\nSYSLOGD=\"-m 0 -s -s -k\"" > /etc/conf.d/sysklogd'

sudo rc-service sysklogd start

#add a password to grub

#sudo bash -c 'read -p "Enter a superuser username: " username && echo "set superusers=\"$username\"" >> /etc/grub.d/40_custom; read -s -p "Enter a superuser password: " password && echo -e "\npassword_pbkdf2 $username $(grub-mkpasswd-pbkdf2 <<< "$password")" >> /etc/grub.d/40_custom && grub-mkconfig -o /boot/grub/grub.cfg'

#disable core dumps

echo '* soft core 0' | sudo tee -a /etc/security/limits.conf > /dev/null && echo "Added line '* soft core 0' to /etc/security/limits.conf"

