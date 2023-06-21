#!/bin/bash

#fonts

sudo emerge media-gfx/fontforge --autounmask{,-write,-continue}

sudo eselect repository add guru git git://github.com/gentoo/guru.git
sudo eselect repository enable guru

sudo emerge --sync 

#nvchad

sudo emerge dev-vcs/lazygit --autounmask{,-write,-continue}
git clone https://github.com/NvChad/NvChad ~/.config/nvim_temp --depth 1 && rsync -av ~/.config/nvim_temp/ ~/.config/nvim/ --exclude .git && rm -rf ~/.config/nvim_temp
sudo emerge -av nodejs
sudo npm install -g yarn
sudo npm install -g npm@9.6.4 --force
sudo npm fund
cd ~/.config/nvim
yarn install --frozen-lockfile
echo -e '\n-- Load packer.nvim\nvim.cmd [[packadd packer.nvim]]\n\n-- Auto-compile and auto-install plugins when you save your plugins.lua file\nvim.cmd [[autocmd BufWritePost plugins.lua PackerCompile]]\nvim.cmd [[autocmd BufWritePost plugins.lua PackerInstall]]\nvim.cmd [[autocmd BufWritePost plugins.lua PackerSync]]' | tee -a ~/.config/nvim/init.lua
rm -rf ~/.local/share/nvim/site/pack/packer/start/packer.nvim
git clone https://github.com/wbthomason/packer.nvim ~/.local/share/nvim/site/pack/packer/start/packer.nvim
mkdir -p ~/.local/share/nvim/nvchad/base46
touch ~/.local/share/nvim/nvchad/base46/defaults
echo "vim.o.packpath = vim.o.packpath .. ',~/.local/share/nvim/site/pack'" | tee -a ~/.config/nvim/init.lua

nvim
git clone https://github.com/nvim-treesitter/nvim-treesitter ~/.local/share/nvim/site/pack/packer/start/nvim-treesitter
nvim
sudo emerge dev-util/bash-language-server --autounmask{,-write,-continue}