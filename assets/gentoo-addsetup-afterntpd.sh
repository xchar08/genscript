#!/bin/bash

echo "Please enter your username:"
read -r us

chown "$us":"$us" /home/user/

#harden compilers
sudo chown root:root /usr/bin/gcc
sudo chown root:root /usr/bin/g++
sudo chown root:root /usr/bin/cc
sudo chown root:root /usr/bin/c++

sudo chmod 0700 /usr/bin/gcc
sudo chmod 0700 /usr/bin/g++
sudo chmod 0700 /usr/bin/cc
sudo chmod 0700 /usr/bin/c++

echo "to revert changes (allow updates), run this command: sudo chmod 755 /usr/bin/gcc /usr/bin/g++ /usr/bin/cc /usr/bin/c++; sudo chown -R '$username':'$username' /usr/bin/gcc /usr/bin/g++ /usr/bin/cc /usr/bin/c++;"
