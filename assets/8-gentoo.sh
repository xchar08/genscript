#!/bin/bash

passwd

emerge -auDN world
dispatch-conf
emerge -auDN world
emerge --depclean

echo "Reboot your computer..."
