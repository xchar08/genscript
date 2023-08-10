#!/bin/bash

# screen recording

sudo emerge media-video/obs-studio --autounmask{,-write,-continue}

# compositor

sudo emerge x11-misc/picom --autounmask{,-write,-continue}

# application manager 

sudo emerge x11-misc/rofi --autounmask{,-write,-continue}

# file manager

sudo emerge app-misc/ranger --autounmask{,-write,-continue}

# clipboard

sudo emerge x11-misc/xclip --autounmask{,-write,-continue}

# notification daemon

sudo emerge x11-misc/dunst --autounmask{,-write,-continue}

# status bar

sudo emerge x11-misc/polybar --autounmask{,-write,-continue}

# wallpaper manager

sudo emerge media-gfx/feh --autounmask{,-write,-continue}

# display configuration

sudo emerge x11-misc/autorandr --autounmask{,-write,-continue}

# screenshot

sudo emerge media-gfx/flameshot --autounmask{,-write,-continue}

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

sudo emerge app-editors/vscode --autounmask{,-write,-continue}

# user input

sudo emerge x11-misc/xdotool --autounmask{,-write,-continue}

# email client 

sudo emerge mail-client/mutt-wizard --autounmask{,-write,-continue}

# other xorg

sudo emerge x11-apps/xsetroot --autounmask{,-write,-continue}
sudo emerge x11-misc/wmname --autounmask{,-write,-continue}
sudo emerge sys-devel/bc --autounmask{,-write,-continue}

sudo emerge x11-base/xorg-server --autounmask{,-write,-continue}

sudo emerge x11-base/xorg-drivers --autounmask{,-write,-continue}