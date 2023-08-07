#!/bin/bash

sudo emerge virtual/jdk --autounmask{,-write,-continue}
sudo emerge virtual/jre --autounmask{,-write,-continue}
sudo emerge dev-java/ant-core --autounmask{,-write,-continue}
sudo emerge dev-util/valgrind --autounmask{,-write,-continue}
sudo emerge app-text/wgetpaste --autounmask{,-write,-continue}

sudo emerge dev-lang/python --autounmask{,-write,-continue}
sudo emerge dev-python/pip --autounmask{,-write,-continue}

sudo rm -rf /etc/portage/package.env
sudo touch /etc/portage/package.env

echo "sys-libs/glibc debugsyms installsources" | sudo tee /etc/portage/package.env

sudo mkdir -p /etc/portage/env
sudo wget -O /etc/portage/env/debugsyms https://raw.githubusercontent.com/xchar08/gentoo-secured-bspwm/main/assets/debugsyms 
sudo wget -O /etc/portage/env/installsources https://raw.githubusercontent.com/xchar08/gentoo-secured-bspwm/main/assets/installsources 
sudo emerge dev-util/debugedit --autounmask{,-write,-continue}
sudo emerge sys-libs/glibc --autounmask{,-write,-continue}
