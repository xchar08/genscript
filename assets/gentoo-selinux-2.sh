#!/bin/bash

# Set SELinux to enforcing mode
sudo setenforce 1

# Check if the audit log directory exists
audit_log_dir="/var/log/audit"
if [[ -d "$audit_log_dir" ]]; then
    echo "Audit log directory exists."
else
    echo "Audit log directory not found. Creating..."
    sudo mkdir -p "$audit_log_dir"
fi

# Check if the audit log file exists
audit_log="/var/log/audit/audit.log"
if [[ -f "$audit_log" ]]; then
    echo "Audit log file exists."
else
    echo "Audit log file not found. Creating..."
    sudo touch "$audit_log"
fi

# Set permissions for the audit log directory and file
sudo chmod 750 "$audit_log_dir"
sudo chmod 640 "$audit_log"
sudo chown root:root "$audit_log"

# Re-enable SELinux
sudo setenforce 1

# Additional configuration steps can be added here
