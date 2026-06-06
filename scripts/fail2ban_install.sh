#!/bin/bash

# Multi-distro fail2ban installer and configurator

# Detect distribution
if [ -f /etc/os-release ]; then
    . /etc/os-release
    DISTRO=$ID
else
    DISTRO=$(uname -s)
fi
echo "[INFO] Detected distro: $DISTRO"

# Install fail2ban based on distro
case "$DISTRO" in
    ubuntu|debian)
        echo "[INFO] Installing fail2ban via apt..."
        sudo apt update && sudo apt install -y fail2ban
        ;;
    centos|rhel|fedora)
        echo "[INFO] Installing fail2ban via dnf/yum..."
        sudo dnf install -y fail2ban || sudo yum install -y fail2ban
        ;;
    arch)
        echo "[INFO] Installing fail2ban via pacman..."
        sudo pacman -Sy --noconfirm fail2ban
        ;;
    *)
        echo "[ERROR] Unsupported distro: $DISTRO"
        exit 1
        ;;
esac

# Configure fail2ban jail.local
echo "[INFO] Writing jail.local configuration..."
sudo tee /etc/fail2ban/jail.local > /dev/null << 'EOF'
[sshd]
enabled  = true
port     = ssh
filter   = sshd
# Multiple log paths for multi-distro support
logpath  = /var/log/auth.log
           /var/log/secure
           /var/log/journal/*
maxretry = 3                                                            
bantime  = 600                                                        
findtime = 300                                                          
EOF
# Number of failed attempts before ban
 # Ban duration in seconds (10 minutes)
  # Time window to count failures (5 minutes)


# Enable and start fail2ban service
echo "[INFO] Enabling and starting fail2ban..."
sudo systemctl enable fail2ban
sudo systemctl restart fail2ban

# Show status
echo "[INFO] Fail2ban status:"
sudo fail2ban-client status sshd
