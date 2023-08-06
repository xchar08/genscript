#!/bin/bash

sudo emerge gui-wm/sway --autounmask{,-write,-continue}

mkdir -p ~/.config/sway/
cp /etc/sway/config ~/.config/sway/

