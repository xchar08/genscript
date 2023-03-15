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

sudo emerge dev-lang/python --autounmask{,-write,-continue}
sudo emerge dev-python/pip --autounmask{,-write,-continue}
sudo emerge sys-power/auto-cpufreq --autounmask{,-write,-continue}
sudo rc-update add auto-cpufreq
sudo rc-service auto-cpufreq start
cd

git clone https://github.com/AdnanHodzic/auto-cpufreq

sudo emerge psutil --autounmask{,-write,-continue}

sudo python3 ./auto-cpufreq/auto_cpufreq/power_helper.py --gnome_power_disable

echo '# settings for when connected to a power source
[charger]
# see available governors by running: cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_available_governors
# preferred governor.
governor = performance

# minimum cpu frequency (in kHz)
# example: for 800 MHz = 800000 kHz --> scaling_min_freq = 800000
# see conversion info: https://www.rapidtables.com/convert/frequency/mhz-to-hz.html
# to use this feature, uncomment the following line and set the value accordingly
# scaling_min_freq = 800000

# maximum cpu frequency (in kHz)
# example: for 1GHz = 1000 MHz = 1000000 kHz -> scaling_max_freq = 1000000
# see conversion info: https://www.rapidtables.com/convert/frequency/mhz-to-hz.html
# to use this feature, uncomment the following line and set the value accordingly
# scaling_max_freq = 1000000

# turbo boost setting. possible values: always, auto, never
turbo = auto

# settings for when using battery power
[battery]
# see available governors by running: cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_available_governors
# preferred governor
governor = powersave

# minimum cpu frequency (in kHz)
# example: for 800 MHz = 800000 kHz --> scaling_min_freq = 800000
# see conversion info: https://www.rapidtables.com/convert/frequency/mhz-to-hz.html
# to use this feature, uncomment the following line and set the value accordingly
# scaling_min_freq = 800000

# maximum cpu frequency (in kHz)
# see conversion info: https://www.rapidtables.com/convert/frequency/mhz-to-hz.html
# example: for 1GHz = 1000 MHz = 1000000 kHz -> scaling_max_freq = 1000000
# to use this feature, uncomment the following line and set the value accordingly
# scaling_max_freq = 1000000

# turbo boost setting. possible values: always, auto, never
turbo = auto' | sudo tee /etc/auto-cpufreq.conf >/dev/null

sudo auto-cpufreq --install

sudo emerge sys-power/cpupower --autounmask{,-write,-continue}

# Checks for pstate and applies required patch

if cpupower frequency-info | grep -q "driver: intel_pstate" && cpupower frequency-info | grep -q "driver: amd_cpufreq"; then
    sudo sed -i '0,/^GRUB_CMDLINE_LINUX/{s/\("[^"]*"\)/"quiet splash intel_pstate=disable initcall_blacklist=amd_pstate_init amd_pstate.enable=0 \1/}' /etc/default/grub
elif cpupower frequency-info | grep -q "driver: intel_pstate"; then
    sudo sed -i '0,/^GRUB_CMDLINE_LINUX/{s/\("[^"]*"\)/"quiet splash intel_pstate=disable \1/}' /etc/default/grub
elif cpupower frequency-info | grep -q "driver: amd_cpufreq"; then
    sudo sed -i '0,/^GRUB_CMDLINE_LINUX/{s/\("[^"]*"\)/"quiet splash initcall_blacklist=amd_pstate_init amd_pstate.enable=0 \1/}' /etc/default/grub
fi



sudo emerge app-laptop/laptop-mode-tools --autounmask{,-write,-continue}
sudo touch /etc/laptop-mode/conf.d/cpufreq.conf
echo "CONTROL_CPU_FREQUENCY=0" | sudo tee /etc/laptop-mode/conf.d/cpufreq.conf
sudo rc-service laptop_mode start 
sudo rc-update add laptop_mode default 

# Firewall

sudo emerge net-firewall/ufw
sudo rc-update add ufw default
sudo rc-service ufw start
sudo ufw deny ssh

source ~/.bashrc