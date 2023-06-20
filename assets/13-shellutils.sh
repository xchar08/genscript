#!/bin/bash

sudo emerge app-shells/fish --autounmask{,-write,-continue}

curl https://raw.githubusercontent.com/oh-my-fish/oh-my-fish/master/bin/install | fish
curl -sS https://starship.rs/install.sh | sh

# add nitch and neofetch

wget https://raw.githubusercontent.com/unxsh/nitch/main/setup.sh && sh setup.sh
sudo emerge app-misc/neofetch --autounmask{,-write,-continue}

curl -o ~/.bashrc https://raw.githubusercontent.com/jpx32/dotfiles-space/master/~/.bashrc