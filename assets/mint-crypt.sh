#!/bin/bash

partuuid=$(blkid | grep "crypto_LUKS" | sed -n 's/.*PARTUUID=\"\([^\"]*\)\".*/\1/p')
echo -n 'Enter device label (e.g. nvme0n1): '
read primpart
echo -n 'Enter efi partition (e.g. nvme0n1p1): '
read efipart
echo -n 'Enter boot partition (e.g. nvme0n1p2): '
read bootpart
echo -n 'Enter root/home partition (e.g. nvme0n1p3): '
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
 
echo -n 'Enter stage 3 tar url: '
read tarurl
wget $tarurl
tar xvJpf stage3-*.tar.xz --xattrs --numeric-owner
echo -e 'COMMON_FLAGS="-O2 -march=native -pipe"\nCFLAGS="${COMMON_FLAGS}"\nCXXFLAGS="${COMMON_FLAGS}"\nFCFLAGS="${COMMON_FLAGS}"\nFFLAGS="${COMMON_FLAGS}"\nMAKEOPTS="-j8"\nACCEPT_KEYWORDS="~amd64"\nACCEPT_LICENSE="*"' >> /mnt/gentoo/etc/portage/make.conf
echo -n 'Video Cards? (e.g. "nvidia" "nvidia intel"): '
read VID_CARDS
echo -e "VIDEO_CARDS=\"$VID_CARDS\"\n" >> /mnt/gentoo/etc/portage/make.conf
echo -e 'USE="-ldap acl alsa bluetooth chroot cryptsetup dbus elogind fuse gecko pulseaudio secure_delete strict vulkan udisks webrsync-gpg wifi"' >> /mnt/gentoo/etc/portage/make.conf
echo -n 'Use hardened? [y/n]: '
read HARD
if [[ "$HARD" == 'y' ]]; then echo -e 'hardened' >> /mnt/gentoo/etc/portage/make.conf; fi
echo -n 'Use Gnome? [y/n]: '
read gninp
if [[ "$gninp" == 'y' ]]; then echo -e 'gnome' >> /mnt/gentoo/etc/portage/make.conf; fi
echo -n 'Use X? [y/n]: '
read Xinp
if [[ "$Xinp" == 'y' && "$gninp" != 'y' ]]; then echo -e 'X xinerama' >> /mnt/gentoo/etc/portage/make.conf; fi

echo -e 'PORTDIR=\"/var/db/repos/gentoo\"\nDISTDIR=\"/var/cache/distfiles\"\nPKGDIR=\"/var/cache/binpkgs\"\nLC_MESSAGES=C\nGENTOO_MIRRORS=\"https://mirror.leaseweb.com/gentoo/ http://mirror.leaseweb.com/gentoo/ rsync://mirror.leaseweb.com/gentoo/\"' >> /mnt/gentoo/etc/portage/make.conf
mkdir /mnt/gentoo/etc/portage/repos.conf 
cp /mnt/gentoo/usr/share/portage/config/repos.conf /mnt/gentoo/etc/portage/repos.conf/gentoo.conf 
cp /etc/resolv.conf /mnt/gentoo/etc/resolv.conf
