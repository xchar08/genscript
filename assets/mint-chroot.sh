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

