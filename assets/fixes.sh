#!/bin/bash

sudo mkdir -p /root/Desktop

sudo rm -rf /run/user/1000/*
sudo mkdir -p /run/user/1000
sudo chown 1000:1000 /run/user/1000
sudo rc-service dbus restart
