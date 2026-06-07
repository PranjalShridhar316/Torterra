#!/bin/bash
# Torterra v3 - SSH key setup for passwordless authentication

set -euo pipefail

# Username passed as argument
USER="${1:-}"

# Ensure username is provided
if [ -z "$USER" ]; then
    echo "Usage: $0 <username>"
    exit 1
fi

# Check if user exists on system
if ! id "$USER" &>/dev/null; then
    echo "[X] User does not exist"
    exit 1
fi

# Get actual home directory of user (safer than $HOME)
USER_HOME=$(getent passwd "$USER" | cut -d: -f6)

# Define SSH directory and key paths
SSH_DIR="$USER_HOME/.ssh"
KEY="$SSH_DIR/id_ed25519"
PUB="$KEY.pub"

echo "[*] Setting up SSH keys for $USER"

# Create .ssh directory with correct permissions
sudo -u "$USER" mkdir -p "$SSH_DIR"
sudo chmod 700 "$SSH_DIR"

# Generate SSH key only if it doesn't already exist
if [ ! -f "$KEY" ]; then
    echo "[*] Generating SSH key pair..."
    sudo -u "$USER" ssh-keygen -t ed25519 -f "$KEY" -N ""
else
    echo "[*] SSH key already exists, skipping generation"
fi

# Copy public key into authorized_keys for authentication
echo "[*] Installing public key..."
sudo cp "$PUB" "$SSH_DIR/authorized_keys"

# Set correct permissions (critical for SSH security)
sudo chmod 600 "$SSH_DIR/authorized_keys"
sudo chown -R "$USER:$USER" "$SSH_DIR"

echo "[✔] SSH key authentication setup complete for $USER"