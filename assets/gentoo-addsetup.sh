#!/bin/bash

#echo "Enter your other username: "
#read -r us
#su $us

# add fish



# tripwire




#sudo mkdir -p /usr/local/portage/dm-overlay
#sudo git clone https://github.com/DrMosquito/dm-overlay.git /usr/local/portage/dm-overlay


#sudo sh -c "echo '[dm-overlay]
#location = /usr/local/portage/dm-overlay
#masters = gentoo
#auto-sync = no' > /etc/portage/repos.conf/dm-overlay.conf"

#sudo mkdir -p /var/db/repos/dm-overlay/metadata && echo "masters = gentoo" | sudo tee /var/db/repos/dm-overlay/metadata/layout.conf
#sudo mkdir -p /var/db/repos/dm-overlay/profiles/
#sudo sh -c "echo 'dm-overlay' > /var/db/repos/dm-overlay/profiles/repo_name"*/

#sudo eix-update
#sudo eselect repository enable dm-overlay
#sudo emerge --sync
#sudo eix-update



# add bashrc and source


#source ~/.bashrc
#exit
#source ~/.config/fish/config.fish

# Add and enable eselect repositories



sudo eselect repository add librewolf git git://github.com/gentoo-mozilla/librewolf-bin.git
sudo eselect repository enable librewolf

sudo eselect repository add guru git git://github.com/gentoo/guru.git
sudo eselect repository enable guru

sudo eselect repository add gentoo-zh git git://github.com/gentoo-zh/gentoo-zh.git
sudo eselect repository enable gentoo-zh

echo "Eselect repositories added and enabled successfully!"





# get nvim thingy



# add wm packages 

sudo emerge x11-wm/dwm --autounmask{,-write,-continue}
sudo emerge x11-misc/rofi --autounmask{,-write,-continue}
sudo emerge x11-misc/wmname --autounmask{,-write,-continue}

# add dwm_bar

sudo emerge x11-apps/xsetroot --autounmask{,-write,-continue}
sudo emerge net-misc/networkmanager net-misc/curl sys-devel/bc sys-power/acpi x11-misc/wmname --autounmask{,-write,-continue}
USE="alsa" sudo emerge media-sound/pulseaudio --autounmask{,-write,-continue}
sudo dispatch-conf
USE="alsa" sudo emerge media-sound/pulseaudio --autounmask{,-write,-continue}
git clone https://github.com/jpx32/dwm_bar.git ~/.scripts && cd ~/.scripts && git checkout master dwm_bar.sh
chmod +x ~/.scripts/dwm_bar.sh

# add configurations

# Clone the git repository into the home directory
git clone https://github.com/jpx32/dotfiles-space/ ~/dotfiles-space

# Copy files from dotfiles-space/~ to the ~ directory of the current user
cp -r ~/dotfiles-space/~/* ~/

# Copy the specified grub theme file to /boot/grub/themes/
sudo cp ~/dotfiles-space/boot/grub/themes/catppuccin-mocha-grub-theme /boot/grub/themes/

# Copy files from dotfiles-space/etc/portage to /etc/portage (excluding make.conf)
sudo cp -r ~/dotfiles-space/etc/portage/env /etc/portage/
sudo cp -r ~/dotfiles-space/etc/portage/repos.conf /etc/portage/
sudo cp -r ~/dotfiles-space/etc/portage/savedconfig /etc/portage
sudo cp -r ~/dotfiles-space/etc/portage/sets /etc/portage/
sudo rm -rf /etc/portage/package.accept_keywords
sudo cp -r ~/dotfiles-space/etc/portage/package.accept_keywords /etc/portage/
sudo rm -rf /etc/portage/package.env
sudo cp -r ~/dotfiles-space/etc/portage/package.env /etc/portage/
sudo rm -rf /etc/portage/package.mask
sudo cp -r ~/dotfiles-space/etc/portage/package.mask /etc/portage/
sudo rm -rf /etc/portage/package.use
sudo cp -r ~/dotfiles-space/etc/portage/package.use /etc/portage/

echo "Dotfiles copied successfully!"

sudo emerge x11-wm/dwm --autounmask{,-write,-continue}

# add programming stuff

less /var/db/repos/gentoo/licenses/Microsoft-vscode
echo "app-editors/vscode Microsoft-vscode" >> /etc/portage/package.license
sudo emerge app-editors/vscode --autounmask{,-write,-continue}
curl https://raw.githubusercontent.com/jpx32/vscode-extensionpack/main/package.json | sudo tee ~/.vscode/extensions/package.json >/dev/null

s

# fonts 






# cpu optimization






