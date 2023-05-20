#!/bin/bash

echo "Do you want to enable SELinux? [y/N]"
read answer
if [[ "$answer" != "${answer#[Yy]}" ]]; then
    sudo emerge selinux-base-policy selinux-policykit sec-policy/selinux-mozilla
    echo 'rc_security="YES"' | sudo tee -a /etc/rc.conf
    sudo setenforce 1
    sudo genpol -v -r /etc -o /etc/selinux/strict/policy.kern
    sudo semanage user -a -R "staff_r sysadm_r user_r" -L s0 -M targeted -s user_u $USER
    sudo auditctl -w /usr/bin/firefox -p x -k firefox
    sudo auditctl -w /usr/bin/firefox -p x -k firefox
    sudo audit2allow -M ${USER}_firefox < /var/log/audit/audit.log
    sudo semodule -i ${USER}_firefox.pp
    sudo chcon -R -t user_home_t /home/$USER
    sudo genpol -v -r /etc -o /etc/selinux/strict/policy.kern
else
    echo "SELinux is not enabled."
fi
