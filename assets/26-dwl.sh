#!/bin/bash

sudo emerge --ask gui-wm/sway --autounmask{,-write,-continue}

mkdir -p ~/.config/sway/
cp /etc/sway/config ~/.config/sway/
