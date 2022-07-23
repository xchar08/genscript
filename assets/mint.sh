partuuid=$(blkid | sed 's/.*PARTUUID="//' | sed 's/.$//')
echo -n 'Enter device label (e.x. nvme0n1): '
read primpart
echo -n 'Enter efi partition (e.x. nvme0n1p1): '
read efipart
echo -n 'Enter boot partition (e.x. nvme0n1p2): '
read bootpart
echo -n 'Enter root/home partition (e.x. nvme0n1p3): '
read lukspart

#cfdisk /dev/'$primpart'
#make 300M fat32 (mkfs.fat -F 32 /dev/'$efipart') and set to efi
#1G ext4 (mkfs.ext4 /dev/'$bootpart')
#200G gentoo home (luks)
parted -a optimal /dev/'$primpart' - mklabel gpt
parted -a optimal /dev/'$primpart' - mkpart esp fat32 0% 512
parted -a optimal /dev/'$primpart' - mkpart swap linux-swap 512 8704
parted -a optimal /dev/'$primpart' - mkpart rootfs btrfs 8704 100%
parted -a optimal /dev/'$primpart' - set 1 boot on

mkfs.fat -F 32 /dev/'$efipart'
mkfs.ext4 /dev/'$bootpart'

cryptsetup luksFormat --type luks2 /dev/'$lukspart'
cryptsetup luksDump /dev/'$lukspart'
blkid
cryptsetup open /dev/nvme0n1p3 luks-'$partuuid'
cd /dev/mapper
mkfs.btrfs /dev/mapper/luks-'$partuuid'
mkdir /mnt/btrfs
mount /dev/mapper/luks-'$partuuid' /mnt/btrfs
cd /mnt/btrfs
btrfs subvolume create ./root
btrfs subvolume create ./home
mkdir -p /mnt/gentoo 
mount -o subvol=root /dev/mapper/luks-'$partuuid' /mnt/gentoo
mkdir /mnt/gentoo/boot
mkdir /mnt/gentoo/home
mount -o subvol=home /dev/mapper/luks-'$partuuid' /mnt/gentoo/home
mount /dev/'$bootpart' /mnt/gentoo/boot
mkdir /mnt/gentoo/boot/efi
mount /dev/'$efipart' /mnt/gentoo/boot/efi
cd /mnt/gentoo
 
wget https://bouncer.gentoo.org/fetch/root/all/releases/amd64/autobuilds/20220626T170536Z/stage3-amd64-hardened-openrc-20220626T170536Z.tar.xz
tar xvJpf stage3-amd64-hardened-openrc-20220626T170536Z.tar.xz --xattrs --numeric-owner
#nano /mnt/gentoo/etc/portage/make.conf

# These settings were set by the catalyst build script that automatically
# built this stage.
# Please consult /usr/share/portage/config/make.conf.example for a more
# detailed example.

echo -e 'COMMON_FLAGS=\"-O2 -march=native -pipe\"\nCFLAGS=\"${COMMON_FLAGS}\"\nCXXFLAGS=\"${COMMON_FLAGS}\"\nFCFLAGS=\"${COMMON_FLAGS}\"\nFFLAGS=\"${COMMON_FLAGS}\"\nMAKEOPTS=\"-j8\"\nACCEPT_KEYWORDS=\"~amd64\"\nACCEPT_LICENSE=\"*\"\n' >> /mnt/gentoo/etc/portage/make.conf
# COMMON_FLAGS="-O2 -march=native -pipe"
# CFLAGS="${COMMON_FLAGS}"
# CXXFLAGS="${COMMON_FLAGS}"
# FCFLAGS="${COMMON_FLAGS}"
# FFLAGS="${COMMON_FLAGS}"
# MAKEOPTS="-j8"
# ACCEPT_KEYWORDS="~amd64"
# ACCEPT_LICENSE="*"
echo -n 'Video Cards? (ex. \"nvidia\" \"nvidia intel\"): '
read VID_CARDS
echo -e 'Video_Cards=\"$VID_CARDS\"\n' >> /mnt/gentoo/etc/portage/make.conf
#VIDEO_CARDS="nvidia intel"
echo -e '\"-ldap acl alsa chroot cryptsetup dbus elogind gecko pulseaudio secure_delete strict vulkan webrsync-gpg wifi' >> /mnt/gentoo/etc/portage/make.conf
echo -n 1 'Use hardened? [y/n]: '
read HARD
if [[ "$HARD" == 'y' ]]; then echo -e ' hardened' >> /mnt/gentoo/etc/portage/make.conf; fi
echo -n 1 'Use X? [y/n]: '
read Xinp
if [[ "$Xinp" == 'y' ]]; then echo -e ' X xinerama' >> /mnt/gentoo/etc/portage/make.conf; fi
echo -e '\"\nPORTDIR=\"/var/db/repos/gentoo\"\nDISTDIR=\"/var/cache/distfiles\"\nPKGDIR=\"/var/cache/binpkgs\"\nLC_MESSAGES=C\nGENTOO_MIRRORS=\"https://mirror.leaseweb.com/gentoo/ http://mirror.leaseweb.com/gentoo/ rsync://mirror.leaseweb.com/gentoo/\"' >> /mnt/gentoo/etc/portage/make.conf
#USE="-ldap acl alsa chroot cryptsetup dbus elogind gecko hardened pulseaudio secure_delete strict vulkan webrsync-gpg wifi X xinerama"
# NOTE: This stage was built with the bindist Use flag enabled
#PORTDIR="/var/db/repos/gentoo"
#DISTDIR="/var/cache/distfiles"
#PKGDIR="/var/cache/binpkgs"

# This sets the language of build output to English.
# Please keep this setting intact when reporting bugs.

#LC_MESSAGES=C
#GENTOO_MIRRORS="https://mirror.leaseweb.com/gentoo/ http://mirror.leaseweb.com/gentoo/ rsync://mirror.leaseweb.com/gentoo/"
mkdir /mnt/gentoo/etc/portage/repos.conf 
cp /mnt/gentoo/usr/share/portage/config/repos.conf /mnt/gentoo/etc/portage/repos.conf/gentoo.conf 
cp /etc/resolv.conf /mnt/gentoo/etc/resolv.conf 
mount --bind /run /mnt/gentoo/run
mount -t proc /proc /mnt/gentoo/proc 
mount --rbind /sys /mnt/gentoo/sys 
mount --make-rslave /mnt/gentoo/sys 
mount --rbind /dev /mnt/gentoo/dev 
mount --make-rslave /mnt/gentoo/dev 
test -L /dev/shm && rm /dev/shm && mkdir /dev/shm 
mount -t tmpfs -o nosuid,nodev,noexec shm /dev/shm 
chmod 1777 /dev/shm 
chroot /mnt/gentoo /bin/bash 
source /etc/profile 
export PS1="(chroot) $PS1" 
emerge-webrsync 
eselect profile list 
echo -n "Select profile (e.x. 1): "
read prof
eselect profile set $prof
#eselect profile set X
emerge --ask app-portage/flaggie --autounmask{,-write,-continue}
flaggie sys-kernel/installkernel-gentoo +grub
emerge --ask app-shells/bash-completion --autounmask{,-write,-continue}
emerge --ask app-portage/gentoolkit --autounmask{,-write,-continue}
echo -n "Select timezone (e.x. America/Eastern): "
read tmzn
echo 'America/$tmz' > /etc/timezone
#echo America/XX > /etc/timezone 
emerge --config sys-libs/timezone-data --autounmask{,-write,-continue}
nano -w /etc/locale.gen 
#*uncomment locale*
locale-gen 
eselect locale list 
echo -n "Select locale (e.x. 1): "
read lclz
eselect locale set $lclz
#eselect locale set X
env-update && source /etc/profile 
blkid
emerge --ask sys-fs/genfstab --autounmask{,-write,-continue}
genfstab -U / > /etc/fstab
nano /etc/fstab
#**get rid of tracefs**
emerge --ask sys-kernel/linux-firmware --autounmask{,-write,-continue}
emerge --ask sys-fs/btrfs-progs --autounmask{,-write,-continue}
emerge --ask sys-apps/pciutils --autounmask{,-write,-continue}
euse -E networkmanager
emerge --ask sys-kernel/gentoo-kernel-bin --autounmask{,-write,-continue}
emerge sys-fs/cryptsetup --autounmask{,-write,-continue}
emerge --config gentoo-kernel-bin --autounmask{,-write,-continue}
echo 'sys-boot/grub:2 device-mapper' >> /etc/portage/package.use/sys-boot 
emerge -a sys-boot/os-prober --autounmask{,-write,-continue}
emerge -av grub --autounmask{,-write,-continue}
partuuid=$(blkid | sed 's/.*PARTUUID="//' | sed 's/.$//')
echo 'GRUB_CMDLINE_LINUX=\"rd.luks.partuuid=$partuuid\"\nGRUB_DISABLE_OS_PROBER=false\nGRUB_DISABLE_LINUX_UUID=true' >> /etc/default/grub
#nano /etc/default/grub
#GRUB_CMDLINE_LINUX='rd.luks.partuuid=$partuuid'
#GRUB_DISABLE_OS_PROBER=false
#to /dev/nvme0n1p3 ^
#uncomment GRUB_DISABLE_LINUX_UUID=true
grub-install --target=x86_64-efi --efi-directory=/boot/efi
grub-mkconfig -o /boot/grub/grub.cfg 
passwd 
emerge --ask app-editors/neovim --autounmask{,-write,-continue}
emerge -auDN world
emerge --depclean
