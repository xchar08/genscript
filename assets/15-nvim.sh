#!/bin/bash

sudo emerge app-eselect/eselect-repository --autounmask{,-write,-continue}

sudo eselect repository add guru git git://github.com/gentoo/guru.git

sudo mkdir -p /var/db/repos/guru/profiles/

sudo touch /var/db/repos/guru/profiles/repo_name

sudo echo guru > /var/db/repos/guru/profiles/repo_name

sudo eselect repository enable guru

sudo emerge --sync

#fonts

sudo emerge media-gfx/fontforge --autounmask{,-write,-continue}
sudo emerge media-fonts/alee-fonts --autounmask{,-write,-continue}
sudo emerge media-fonts/cantarell --autounmask{,-write,-continue}
sudo emerge media-fonts/corefonts --autounmask{,-write,-continue}
sudo emerge media-fonts/courier-prime --autounmask{,-write,-continue}
sudo emerge media-fonts/arphicfonts --autounmask{,-write,-continue}
sudo emerge media-fonts/dejavu --autounmask{,-write,-continue}
sudo emerge media-fonts/droid --autounmask{,-write,-continue}
sudo emerge media-fonts/encodings --autounmask{,-write,-continue}
sudo emerge media-fonts/farsi-fonts --autounmask{,-write,-continue}
sudo emerge media-fonts/fira-code --autounmask{,-write,-continue}
sudo emerge media-fonts/fira-mono --autounmask{,-write,-continue}
sudo emerge media-fonts/fira-sans --autounmask{,-write,-continue}
sudo emerge media-fonts/font-alias --autounmask{,-write,-continue}
sudo emerge media-fonts/font-bh-ttf --autounmask{,-write,-continue}
sudo emerge media-fonts/font-cursor-misc --autounmask{,-write,-continue}
sudo emerge media-fonts/font-misc-misc --autounmask{,-write,-continue}
sudo emerge media-fonts/font-util --autounmask{,-write,-continue}
sudo emerge media-fonts/fonts-meta --autounmask{,-write,-continue}
sudo emerge media-fonts/kochi-substitute --autounmask{,-write,-continue}
sudo emerge media-fonts/liberation-fonts --autounmask{,-write,-continue}
sudo emerge media-fonts/lohit-bengali --autounmask{,-write,-continue}
sudo emerge media-fonts/lohit-tamil --autounmask{,-write,-continue}
sudo emerge media-fonts/mikachan-font-ttf --autounmask{,-write,-continue}
sudo emerge media-fonts/noto --autounmask{,-write,-continue}
sudo emerge media-fonts/noto-emoji --autounmask{,-write,-continue}
sudo emerge media-fonts/oldstandard --autounmask{,-write,-continue}
sudo emerge media-fonts/open-sans --autounmask{,-write,-continue}
sudo emerge media-fonts/powerline-symbols --autounmask{,-write,-continue}
sudo emerge media-fonts/quivira --autounmask{,-write,-continue}
sudo emerge media-fonts/roboto --autounmask{,-write,-continue}
sudo emerge media-fonts/signika --autounmask{,-write,-continue}
sudo emerge media-fonts/source-code-pro --autounmask{,-write,-continue}
sudo emerge media-fonts/terminus-font --autounmask{,-write,-continue}
sudo emerge media-fonts/tex-gyre --autounmask{,-write,-continue}
sudo emerge media-fonts/thaifonts-scalable --autounmask{,-write,-continue}
sudo emerge media-fonts/ttf-bitstream-vera --autounmask{,-write,-continue}
sudo emerge media-fonts/ubuntu-font-family --autounmask{,-write,-continue}
sudo emerge media-fonts/urw-fonts --autounmask{,-write,-continue}

mkdir -p ~/.local/share/fonts

cd ~/.local/share/fonts

wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.2/FiraCode.zip #firacode nerd font
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.2/FantasqueSansMono.zip #fantasque nerd font
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.2/NerdFontsSymbolsOnly.zip #nerd font symbols
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.2/SourceCodePro.zip #source code pro nerd font
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.2/Ubuntu.zip #ubuntu nerd font

sudo fc-cache -f -v

#nvchad

sudo emerge dev-vcs/lazygit --autounmask{,-write,-continue}
sudo emerge -av nodejs
sudo npm install -g yarn
sudo npm install -g npm@9.6.4 --force
sudo npm fund
git clone https://github.com/CordlessCoder/SomewhatOtiose ~/.config/nvim/
