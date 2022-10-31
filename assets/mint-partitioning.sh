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
parted -a optimal /dev/$primpart -- mklabel gpt
parted -a optimal /dev/$primpart -- mkpart esp fat32 0% 512
parted -a optimal /dev/$primpart -- mkpart swap linux-swap 512 8704
parted -a optimal /dev/$primpart -- mkpart rootfs btrfs 8704 30%
parted -a optimal /dev/$primpart -- set 1 boot on

mkfs.fat -F 32 /dev/$efipart
mkfs.ext4 /dev/$bootpart

cryptsetup luksFormat --type luks2 /dev/$lukspart
cryptsetup luksDump /dev/$lukspart
blkid
cryptsetup open /dev/nvme0n1p3 luks-$partuuid
