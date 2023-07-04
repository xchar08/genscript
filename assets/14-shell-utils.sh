#!/bin/bash

cd

sudo emerge app-shells/zsh --autounmask{,-write,-continue}
sudo emerge app-shells/zsh-completions --autounmask{,-write,-continue}
sudo emerge app-shells/gentoo-zsh-completions --autounmask{,-write,-continue}

sudo sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
curl -sS https://starship.rs/install.sh | sudo sh
sudo eval "$(starship init zsh)"

# add nitch and neofetch

wget https://raw.githubusercontent.com/unxsh/nitch/main/setup.sh && sudo sh setup.sh
sudo emerge app-misc/neofetch --autounmask{,-write,-continue}
