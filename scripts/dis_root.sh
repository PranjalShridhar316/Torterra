#!/bin/bash
# Disable root login by replacing sshd_config

CONFIG_FILE="../configs/sshd_config"
TARGET_FILE="/etc/ssh/sshd_config"

# Step 1: Ensure config file exists
if [ ! -f "$CONFIG_FILE" ]; then
    echo "Config file not found at $CONFIG_FILE. Copying system config instead..."
    if [ -f "$TARGET_FILE" ]; then
        mkdir -p ../configs
        sudo cp "$TARGET_FILE" "$CONFIG_FILE"
    else
        echo "System sshd_config not found. Exiting."
        exit 1
    fi
fi

# Step 2: Apply hardened config
sudo cp "$CONFIG_FILE" "$TARGET_FILE"

# Step 3: Restart SSH service (multi-distro)
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

echo "Root login disabled     .      ."
echo "                         /\/\/\ "