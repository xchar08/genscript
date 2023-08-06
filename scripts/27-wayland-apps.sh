#!/bin/bash

# screen recording

sudo emerge media-video/obs-studio --autounmask{,-write,-continue}

# network transparency

sudo emerge gui-apps/waypipe --autounmask{,-write,-continue}

sudo dispatch-conf

# screenshare

sudo emerge sys-apps/xdg-desktop-portal --autounmask{,-write,-continue}
sudo emerge gui-libs/xdg-desktop-portal-wlr --autounmask{,-write,-continue}

# powermenu 

sudo emerge gui-apps/wayland-logout --autounmask{,-write,-continue}
sudo emerge gui-apps/swaylock --autounmask{,-write,-continue}
sudo emerge gui-apps/swayidle --autounmask{,-write,-continue}

# file manager

sudo emerge dev-libs/bemenu --autounmask{,-write,-continue}

# clipboard

sudo emerge gui-apps/wl-clipboard --autounmask{,-write,-continue}

# notification daemon

sudo emerge gui-apps/mako --autounmask{,-write,-continue}

# status bar

#sudo emerge gui-apps/waybar --autounmask{,-write,-continue}

# wallpaper manager

sudo emerge gui-apps/swaybg --autounmask{,-write,-continue}

# display configuration

sudo emerge gui-apps/kanshi --autounmask{,-write,-continue}

# screenshot

#sudo emerge gui-apps/grim --autounmask{,-write,-continue}
#sudo emerge gui-apps/slurp --autounmask{,-write,-continue}

# archive manager

sudo emerge app-arch/p7zip --autounmask{,-write,-continue}

# pdf reader

sudo emerge app-text/zathura-pdf-mupdf --autounmask{,-write,-continue}

# office suite

sudo emerge app-office/libreoffice --autounmask{,-write,-continue}

# xmpp client

sudo emerge net-im/profanity --autounmask{,-write,-continue}

# torrenting

sudo emerge net-p2p/qbittorrent --autounmask{,-write,-continue}

# rss reader

sudo emerge net-news/newsboat --autounmask{,-write,-continue}

# terminal-based web browser

#sudo emerge www-client/nyxt --autounmask{,-write,-continue}

# password manager

sudo emerge app-admin/pass --autounmask{,-write,-continue}

#camera 

sudo emerge media-video/cheese --autounmask{,-write,-continue}

# image viewer

sudo emerge media-gfx/sxiv --autounmask{,-write,-continue}

# music player

sudo emerge media-video/mpv --autounmask{,-write,-continue}

# media downloader 

sudo emerge net-misc/yt-dlp --autounmask{,-write,-continue}

# video editor

sudo emerge kde-apps/kdenlive --autounmask{,-write,-continue}
sudo emerge media-libs/libsdl --autounmask{,-write,-continue}

# coding

sudo emerge app-editors/vscodium --autounmask{,-write,-continue}

# user input

sudo emerge x11-misc/ydotool --autounmask{,-write,-continue}

# email client 

sudo emerge mail-client/mutt-wizard --autounmask{,-write,-continue}
