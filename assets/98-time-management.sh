#!/bin/bash

sudo emerge ntp

#fix ntp
sudo rc-service ntpd start && sleep 1 && sudo ntpq -p | awk 'NR>2 && $3=="-" {print $1}' | xargs -I{} sudo ntpq -r remove {} && sudo ntpdate ntp.pool.org && echo "server ntp.pool.org" | sudo tee -a /etc/ntp.conf > /dev/null && sudo rc-service ntpd restart
