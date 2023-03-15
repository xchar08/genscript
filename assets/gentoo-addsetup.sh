#!/bin/bash

# add bashrc and source

curl -o ~/.bashrc https://raw.githubusercontent.com/jpx32/dotfiles-space/master/~/.bashrc

# add eselect repositories

sudo emerge app-eselect/eselect-repository --autounmask{,-write,-continue}

sudo eselect repository add torbrowser git https://gitweb.torproject.org/torbrowser-overlay.git
sudo eselect repository enable torbrowser
sudo eselect repository add steam-overlay git https://github.com/anyc/steam-overlay.git
sudo eselect repository enable steam-overlay
sudo eselect repository add librewolf git https://github.com/gentoo-mozilla/librewolf-bin.git
sudo eselect repository enable librewolf
sudo eselect repository add guru git https://github.com/gentoo/guru.git
sudo eselect repository enable guru
sudo eselect repository add gentoo-zh git https://github.com/gentoo-zh/gentoo-zh.git
sudo eselect repository enable gentoo-zh

# add nitch and neofetch

wget https://raw.githubusercontent.com/unxsh/nitch/main/setup.sh && sh setup.sh
sudo emerge app-misc/neofetch --autounmask{,-write,-continue}

# get nvim thingy

sudo emerge dev-vcs/lazygit --autounmask{,-write,-continue}
git clone https://github.com/NvChad/NvChad ~/.config/nvim --depth 1 && nvim

# add wm packages 

sudo emerge x11-wm/dwm --autounmask{,-write,-continue}
sudo emerge x11-misc/rofi --autounmask{,-write,-continue}
sudo emerge x11-misc/wmname --autounmask{,-write,-continue}

# add dwm_bar

sudo emerge x11-apps/xsetroot --autounmask{,-write,-continue}
sudo emerge net-misc/networkmanager net-misc/curl sys-devel/bc sys-power/acpi x11-misc/wmname --autounmask{,-write,-continue}
USE="alsa" sudo emerge media-sound/pulseaudio --autounmask{,-write,-continue}
sudo dispatch-conf
USE="alsa" sudo emerge media-sound/pulseaudio --autounmask{,-write,-continue}
git clone https://github.com/jpx32/dwm_bar.git ~/.scripts && cd ~/.scripts && git checkout master dwm_bar.sh
chmod +x ~/.scripts/dwm_bar.sh

# add configurations

#dots
git clone https://github.com/jpx32/dotfiles-space.git ~/dotfiles
cd ~/dotfiles
git submodule update --init --recursive
sudo rsync -av --exclude '.git' . ~/
#grub
sudo mkdir -p /boot/grub/themes/catppuccin-mocha-grub-theme
sudo rsync -av /boot/grub/themes/catppuccin-mocha-grub-theme/ ~/dotfiles/boot/grub/themes/catppuccin-mocha-grub-theme/
#etc
sudo rsync -av /etc/ ~/dotfiles/etc/

# add programming stuff

less /var/db/repos/gentoo/licenses/Microsoft-vscode
echo "app-editors/vscode Microsoft-vscode" >> /etc/portage/package.license
sudo emerge app-editors/vscode --autounmask{,-write,-continue}
curl https://raw.githubusercontent.com/jpx32/vscode-extensionpack/main/package.json | sudo tee ~/.vscode/extensions/package.json >/dev/null

sudo emerge virtual/jdk --autounmask{,-write,-continue}
sudo emerge virtual/jre --autounmask{,-write,-continue}
sudo emerge dev-java/ant-core --autounmask{,-write,-continue}
sudo emerge dev-util/valgrind --autounmask{,-write,-continue}

# fonts 

sudo emerge media-gfx/fontforge --autounmask{,-write,-continue}
sudo emerge media-fonts/alee-fonts media-fonts/cantarell media-fonts/corefonts media-fonts/courier-prime media-fonts/arphicfonts media-fonts/dejavu media-fonts/droid media-fonts/encodings media-fonts/farsi-fonts media-fonts/fira-code media-fonts/fira-mono media-fonts/fira-sans media-fonts/font-alias media-fonts/font-bh-ttf media-fonts/font-cursor-misc media-fonts/font-misc-misc media-fonts/font-util media-fonts/fonts-meta media-fonts/kochi-substitute media-fonts/liberation-fonts media-fonts/lohit-bengali media-fonts/lohit-tamil media-fonts/mikachan-font-ttf media-fonts/nerd-fonts media-fonts/noto media-fonts/noto-emoji media-fonts/oldstandard media-fonts/open-sans media-fonts/powerline-symbols media-fonts/quivira media-fonts/roboto media-fonts/signika media-fonts/source-code-pro media-fonts/terminus-font media-fonts/tex-gyre media-fonts/thaifonts-scalable media-fonts/ttf-bitstream-vera media-fonts/ubuntu-font-family media-fonts/urw-fonts --autounmask{,-write,-continue}

# tor 

sudo emerge net-vpn/tor --autounmask{,-write,-continue}
sudo rc-service tor start
sudo rc-update add tor default 

# web browsers

sudo emerge www-client/torbrowser-launcher --autounmask{,-write,-continue}
sudo emerge www-client/librewolf --autounmask{,-write,-continue}

# cpu optimization

sudo emerge sys-power/auto-cpufreq
sudo rc-update add auto-cpufreq
sudo rc-service auto-cpufreq start

source ~/.bashrc