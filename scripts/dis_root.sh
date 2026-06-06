#!/bin/bash
# Disable root login by replacing sshd_config

CONFIG_FILE="../configs/sshd_config"
TARGET_FILE="/etc/ssh/sshd_config"

if [ ! -f "$CONFIG_FILE" ]; then
    echo "Config file not found: $CONFIG_FILE"
    exit 1
fi

sudo cp "$CONFIG_FILE" "$TARGET_FILE"

# Restart SSH service (multi-distro)
if [ -f /etc/os-release ]; then
    . /etc/os-release
    case "$ID" in
        debian|ubuntu)
            sudo systemctl restart ssh
            ;;
        rhel|centos|fedora|arch)
            sudo systemctl restart sshd
            ;;
        *)
            echo "Unsupported distribution: $ID"
            exit 1
            ;;
    esac
fi

echo "Root login disabled and SSH hardened."
