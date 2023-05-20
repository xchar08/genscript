#!/bin/bash

# Set SELinux to enforcing mode
sudo setenforce 1

# Check if the audit log directory exists and has the correct permissions
audit_log_dir="/var/log/audit"
if [[ -d "$audit_log_dir" && -r "$audit_log_dir" ]]; then
    echo "Audit log directory exists and is accessible."
else
    echo "Audit log directory not found or inaccessible. Creating..."
    sudo mkdir -p "$audit_log_dir"
    sudo chmod 750 "$audit_log_dir"
fi

# Check if the audit log file exists and has the correct permissions
audit_log="/var/log/audit/audit.log"
if [[ -f "$audit_log" && -r "$audit_log" ]]; then
    echo "Audit log file exists and is accessible."
else
    echo "Audit log file not found or inaccessible. Creating..."
    sudo touch "$audit_log"
    sudo chmod 640 "$audit_log"
    sudo chown root:root "$audit_log"
fi

# Additional configuration steps can be added here
