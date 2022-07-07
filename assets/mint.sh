cfdisk /dev/nvme0n1
make 300M fat32 (mkfs.fat -F 32 /dev/nvme0n1p1) and set to efi
1G ext4 (mkfs.ext4 /dev/nvme0n1p2)
200G gentoo home (luks)
cryptsetup luksFormat --type luks2 /dev/nvme0n1p3
cryptsetup luksDump /dev/nvme0n1p3
blkid
cryptsetup open /dev/nvme0n1p3 luks-$partuuid
cd /dev/mapper
mkfs.btrfs /dev/mapper/luks-$partuuid
mkdir /mnt/btrfs
mount /dev/mapper/luks-$partuuid /mnt/btrfs
cd /mnt/btrfs
btrfs subvolume create ./root
btrfs subvolume create ./home
mkdir -p /mnt/gentoo 
mount -o subvol=root /dev/mapper/luks-$partuuid /mnt/gentoo
mkdir /mnt/gentoo/boot
mkdir /mnt/gentoo/home
mount -o subvol=home /dev/mapper/luks-$partuuid /mnt/gentoo/home
mount /dev/nvme0n1p2 /mnt/gentoo/boot
mkdir /mnt/gentoo/boot/efi
mount /dev/nvme0n1p1 /mnt/gentoo/boot/efi
cd /mnt/gentoo
 
wget https://bouncer.gentoo.org/fetch/root/all/releases/amd64/autobuilds/20220626T170536Z/stage3-amd64-hardened-openrc-20220626T170536Z.tar.xz
tar xvJpf stage3-amd64-hardened-openrc-20220626T170536Z.tar.xz --xattrs --numeric-owner
nano /mnt/gentoo/etc/portage/make.conf

# These settings were set by the catalyst build script that automatically
# built this stage.
# Please consult /usr/share/portage/config/make.conf.example for a more
# detailed example.
COMMON_FLAGS="-O2 -march=native -pipe"
CFLAGS="${COMMON_FLAGS}"
CXXFLAGS="${COMMON_FLAGS}"
FCFLAGS="${COMMON_FLAGS}"
FFLAGS="${COMMON_FLAGS}"
MAKEOPTS="-j8"
ACCEPT_KEYWORDS="~amd64"
ACCEPT_LICENSE="*"
VIDEO_CARDS="nvidia intel"

USE="-ldap acl alsa chroot cryptsetup dbus elogind gecko hardened pulseaudio secure_delete strict vulkan webrsync-gpg wifi X xinerama"

# NOTE: This stage was built with the bindist Use flag enabled
PORTDIR="/var/db/repos/gentoo"
DISTDIR="/var/cache/distfiles"
PKGDIR="/var/cache/binpkgs"

# This sets the language of build output to English.
# Please keep this setting intact when reporting bugs.
LC_MESSAGES=C
GENTOO_MIRRORS="https://mirror.leaseweb.com/gentoo/ http://mirror.leaseweb.com/gentoo/ rsync://mirror.leaseweb.com/gentoo/"
 
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
eselect profile set X
emerge --ask app-portage/flaggie
flaggie sys-kernel/installkernel-gentoo +grub
emerge --ask app-shells/bash-completion
emerge --ask app-portage/gentoolkit
echo America/XX > /etc/timezone 
emerge --config sys-libs/timezone-data 
nano -w /etc/locale.gen 
 
*uncomment locale*

locale-gen 
eselect locale list 
eselect locale set X
env-update && source /etc/profile 
blkid
emerge --ask sys-fs/genfstab
genfstab -U / > /etc/fstab
nano /etc/fstab

**get rid of tracefs**

emerge --ask sys-kernel/linux-firmware
emerge --ask sys-fs/btrfs-progs
emerge --ask sys-apps/pciutils
euse -E networkmanager
emerge --ask sys-kernel/gentoo-kernel-bin
emerge sys-fs/cryptsetup 
emerge --config gentoo-kernel-bin
echo "sys-boot/grub:2 device-mapper" >> /etc/portage/package.use/sys-boot 
emerge -a sys-boot/os-prober 
emerge -av grub 
blkid
nano /etc/default/grub

GRUB_CMDLINE_LINUX="rd.luks.partuuid=$partuuid"

GRUB_DISABLE_OS_PROBER=false

to /dev/nvme0n1p3 ^

uncomment GRUB_DISABLE_LINUX_UUID=true

grub-install --target=x86_64-efi --efi-directory=/boot/efi
grub-mkconfig -o /boot/grub/grub.cfg 
passwd 
emerge --ask app-editors/neovim
emerge -auDN world
emerge --depclean
