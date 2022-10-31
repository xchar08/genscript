partuuid=$(blkid | sed 's/.*PARTUUID="//' | sed 's/.$//')
echo -n 'Enter device label (e.x. nvme0n1): '
read primpart
echo -n 'Enter efi partition (e.x. nvme0n1p1): '
read efipart
echo -n 'Enter boot partition (e.x. nvme0n1p2): '
read bootpart
echo -n 'Enter root/home partition (e.x. nvme0n1p3): '
read lukspart

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
mount /dev/$bootpart /mnt/gentoo/boot
mkdir /mnt/gentoo/boot/efi
mount /dev/$efipart /mnt/gentoo/boot/efi
cd /mnt/gentoo
 
wget https://bouncer.gentoo.org/fetch/root/all/releases/amd64/autobuilds/20220828T170542Z/stage3-amd64-hardened-openrc-20220828T170542Z.tar.xz
tar xvJpf stage3-amd64-hardened-openrc-20220828T170542Z.tar.xz --xattrs --numeric-owner
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
echo -e '\"-ldap acl alsa bluetooth chroot cryptsetup dbus elogind fuse gecko pulseaudio secure_delete strict vulkan udisks webrsync-gpg wifi' >> /mnt/gentoo/etc/portage/make.conf
echo -n 1 'Use hardened? [y/n]: '
read HARD
if [[ "$HARD" == 'y' ]]; then echo -e ' hardened' >> /mnt/gentoo/etc/portage/make.conf; fi
echo -n 1 'Use X? [y/n]: '
read Xinp
if [[ "$Xinp" == 'y' ]]; then echo -e ' X xinerama' >> /mnt/gentoo/etc/portage/make.conf; fi
echo -n 1 'Use Wayland? [y/n]: '
read Wimp
if [[ "$Winp" == 'y' ]]; then echo -e ' wayland' >> /mnt/gentoo/etc/portage/make.conf; fi
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
