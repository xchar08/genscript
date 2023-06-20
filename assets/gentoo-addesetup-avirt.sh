



#password manager
sudo emerge app-admin/keepassxc --autounmask{,-write,-continue}



#thunderbird

sudo emerge mail-client/thunderbird --autounmask{,-write,-continue}
xdg-mime default thunderbird.desktop x-scheme-handler/mailto



#sudo eselect repository add dm-overlay git https://github.com/damex-overlay/dm-overlay.git



#change file perms
sudo chmod -R go-rwx ~
echo 'to change them back, run sudo chown $username /path/'


#restart system

mkdir "/home/$USER/Desktop"
sudo mkdir -p /usr/local/portage/dm-overlay/metadata
sudo touch /usr/local/portage/dm-overlay/metadata/layout.conf
echo "masters = gentoo" | sudo tee /usr/local/portage/dm-overlay/metadata/layout.conf
