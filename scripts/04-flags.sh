#!/bin/bash

set -e

# Source the system profile
source /etc/profile

# Set the chroot prompt
export PS1="(chroot) $PS1"

# Sync the portage tree
emerge-webrsync

# Select the profile
eselect profile list
read -rp "Select profile (e.g. 1): " profile
eselect profile set "$profile"

echo "Enter the video cards string: (ex. nouveau nvidia intel i915 amdgpu): "
read -r video_cards

echo "Enter the USE flags: (ex. -ldap acl alsa bluetooth chroot cryptsetup cups dbus elogind gecko -kde man networkmanager pulseaudio screencast secure_delete strict valgrind vulkan webrsync-gpg wifi X xinerama ) "
read -r use_flags

echo "Enter how many parallel jobs you want to run (maybe 8)"
read -r num_jobs

cat <<EOF > /etc/portage/make.conf
COMMON_FLAGS="-O2 -march=native -pipe"
CFLAGS="\${COMMON_FLAGS}"
CXXFLAGS="\${COMMON_FLAGS}"
FCFLAGS="\${COMMON_FLAGS}"
FFLAGS="\${COMMON_FLAGS}"
MAKEOPTS="-j${num_jobs}"
ACCEPT_KEYWORDS="~amd64"
ACCEPT_LICENSE="*"

VIDEO_CARDS="$video_cards"
USE="$use_flags"

PORTDIR="/var/db/repos/gentoo"
DISTDIR="/var/cache/distfiles"
PKGDIR="/var/cache/binpkgs"
LC_MESSAGES=C
GENTOO_MIRRORS="https://mirror.leaseweb.com/gentoo/ http://mirror.leaseweb.com/gentoo/ rsync://mirror.leaseweb.com/gentoo/"
EOF
