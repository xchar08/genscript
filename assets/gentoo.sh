source /etc/profile 
export PS1="(chroot) $PS1" 
emerge-webrsync 
eselect profile list 
echo -n 1 "Select profile (e.x. 1): "
read prof
eselect profile set $prof
#eselect profile set X
emerge --ask app-portage/flaggie --autounmask{,-write,-continue}
flaggie sys-kernel/installkernel-gentoo +grub
emerge --ask app-shells/bash-completion --autounmask{,-write,-continue}
emerge --ask app-portage/gentoolkit --autounmask{,-write,-continue}
emerge --ask app-portage/eix --autounmask{,-write,-continue}
echo -n 1 "Select timezone (e.x. America/Eastern): "
read tmzn
echo "${tmzn}" > /etc/timezone
#echo America/XX > /etc/timezone 
emerge --config sys-libs/timezone-data --autounmask{,-write,-continue}
nano -w /etc/locale.gen 
#*uncomment locale* (#en_US.UTF-8 UTF-8)
locale-gen 
eselect locale list 
echo -n 1 "Select locale (e.x. 1): "
read lclz
eselect locale set $lclz
#eselect locale set X
env-update && source /etc/profile 
blkid
emerge --ask sys-fs/genfstab --autounmask{,-write,-continue}
genfstab -U / > /etc/fstab
nano /etc/fstab
#**get rid of tracefs**
#set up zram
modprobe zram
echo $((6144*1024*1024)) > /sys/block/zram0/disksize
mkswap /dev/zram0
swapon /dev/zram0 -p 10
touch /etc/local.d/zram.start
touch /etc/local.d/zram.stop
chmod +x /etc/local.d/zram.start
chmod +x /etc/local.d/zram.stop
rc-update add local default
#kernel generation
emerge --ask sys-kernel/linux-firmware --autounmask{,-write,-continue}
emerge --ask sys-fs/btrfs-progs --autounmask{,-write,-continue}
emerge --ask sys-apps/pciutils --autounmask{,-write,-continue}
emerge --ask sys-apps/lm-sensors --autounmask{,-write,-continue}
rc-update add lm_sensors default
rc-service lm_sensors start
rc-update add elogind boot
euse -E networkmanager
emerge --ask sys-kernel/gentoo-kernel-bin --autounmask{,-write,-continue}
emerge sys-fs/cryptsetup --autounmask{,-write,-continue}
emerge --config gentoo-kernel-bin --autounmask{,-write,-continue}
echo 'sys-boot/grub:2 device-mapper' >> /etc/portage/package.use/sys-boot 
emerge -a sys-boot/os-prober --autounmask{,-write,-continue}
emerge -av grub --autounmask{,-write,-continue}
partuuid=$(blkid | sed 's/.*PARTUUID="//' | sed 's/.$//')
echo 'GRUB_CMDLINE_LINUX=\"rd.luks.partuuid=${partuuid}\"\nGRUB_DISABLE_OS_PROBER=false\nGRUB_DISABLE_LINUX_UUID=true' >> /etc/default/grub
#nano /etc/default/grub
#GRUB_CMDLINE_LINUX='rd.luks.partuuid=$partuuid'
#GRUB_DISABLE_OS_PROBER=false
#to /dev/nvme0n1p3 ^
#uncomment GRUB_DISABLE_LINUX_UUID=true
grub-install --target=x86_64-efi --efi-directory=/boot/efi
grub-mkconfig -o /boot/grub/grub.cfg 
passwd 
modprobe nvidia
emerge --ask app-editors/neovim --autounmask{,-write,-continue}
emerge -auDN world
emerge --depclean

