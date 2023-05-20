#!/bin/bash

echo "Do you want to enable SELinux? [y/N]"
read answer
if [[ "$answer" != "${answer#[Yy]}" ]]; then
    sudo emerge selinux-base-policy selinux-policykit sec-policy/selinux-mozilla policycoreutils
    echo 'rc_security="YES"' | sudo tee -a /etc/rc.conf
    sudo setenforce 1
    sudo semanage user -a -R "staff_r sysadm_r user_r" -L s0 -M targeted -s user_u $USER
    sudo audit2allow -M ${USER}_firefox < /var/log/audit/audit.log
    sudo semodule -i ${USER}_firefox.pp
    sudo restorecon -R -v /home/$USER
else
    echo "SELinux is not enabled."
fi
