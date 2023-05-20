#!/bin/bash

echo "Do you want to enable SELinux? [y/N]"
read answer
if [[ "$answer" != "${answer#[Yy]}" ]]; then
    sudo emerge selinux-base-policy selinux-policykit sec-policy/selinux-mozilla policycoreutils

    # Check if the audit log file exists and has the correct permissions
    audit_log="/var/log/audit/audit.log"
    if [[ -f "$audit_log" && -r "$audit_log" ]]; then
        sudo semodule -DB # Disable SELinux policies
        sudo setenforce 0 # Set SELinux to permissive mode temporarily

        # Generate SELinux policy modules from audit log
        sudo ausearch -c 'firefox' --raw | sudo audit2allow -M ${USER}_firefox

        # Load the generated policy module
        sudo semodule -i ${USER}_firefox.pp

        # Re-enable SELinux and restore the correct permissions
        sudo setenforce 1
        sudo semodule -B # Re-enable SELinux policies
        sudo restorecon -R -v /home/$USER
    else
        echo "Audit log file not found or inaccessible."
        echo "Please ensure that SELinux is properly configured and the audit log is available."
    fi
else
    echo "SELinux is not enabled."
fi
