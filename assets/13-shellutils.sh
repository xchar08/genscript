#!/bin/bash

echo "Please enter your username:"
read -r us

su "$us"

sudo emerge app-shells/fish --autounmask{,-write,-continue}

sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
curl -sS https://starship.rs/install.sh | sh
eval "$(starship init zsh)"

# add nitch and neofetch

wget https://raw.githubusercontent.com/unxsh/nitch/main/setup.sh && sh setup.sh
sudo emerge app-misc/neofetch --autounmask{,-write,-continue}