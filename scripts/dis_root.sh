#!/bin/bash
# Torterra v3 - Disable root SSH login safely (multi-distro)

set -euo pipefail

# Path to SSH configuration file
SSHD_CONFIG="/etc/ssh/sshd_config"

# Backup file with timestamp for rollback safety
BACKUP="/etc/ssh/sshd_config.bak_$(date +%F_%T)"

echo "[*] Detecting SSH service..."

# Detect correct SSH service name based on system
if systemctl list-units --type=service | grep -q "ssh.service"; then
    SSH_SERVICE="ssh"
else
    SSH_SERVICE="sshd"
fi

# Create backup before modifying anything (safety first)
echo "[*] Backing up SSH config..."
sudo cp "$SSHD_CONFIG" "$BACKUP"

echo "[*] Disabling root login..."

# Disable root SSH login (prevents direct root access over SSH)
sudo sed -i 's/^#\?PermitRootLogin.*/PermitRootLogin no/' "$SSHD_CONFIG"

# Validate SSH configuration before restarting service
echo "[*] Validating SSH config..."
sudo sshd -t

# Restart SSH service depending on distro
echo "[*] Restarting SSH service..."
sudo systemctl restart "$SSH_SERVICE"

echo "[✔] Root SSH login disabled safely"