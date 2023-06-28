#!/bin/bash

echo 'POLICY_TYPES="strict targeted"' | sudo tee -a /etc/portage/make.conf

# Check if SELinux is enabled
if [[ $(getenforce) == "Enforcing" ]]; then
    echo "SELinux is enabled."
else
    echo "SELinux is not enabled. Enabling SELinux..."

    # Install SELinux packages
    sudo emerge selinux-base-policy selinux-policykit sec-policy/selinux-mozilla

    # Enable SELinux in rc.conf
    echo 'rc_security="YES"' | sudo tee -a /etc/rc.conf

    # Reboot the system to enable SELinux
    echo "Reboot your system..."
fi

