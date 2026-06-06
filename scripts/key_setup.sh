#!/bin/bash
# Script to enforce SSH key authentication and disable password login

USER=$1                               # Take username as argument (e.g., ./key_setup.sh inoske)
SSH_DIR="/home/$USER/.ssh"            # Path to user's SSH directory

# Step 1: Ensure .ssh directory exists with correct permissions
sudo mkdir -p $SSH_DIR
sudo chmod 700 $SSH_DIR
sudo chown $USER:$USER $SSH_DIR

# Step 2: Add public key (use calling user's key, not root's)
PUB_KEY="/home/$USER/.ssh/id_ed25519.pub"
if [ ! -f "$PUB_KEY" ]; then
    echo "Public key not found at $PUB_KEY. Generate one with: ssh-keygen -t ed25519"
    exit 1
fi

sudo cp "$PUB_KEY" $SSH_DIR/authorized_keys
sudo chmod 600 $SSH_DIR/authorized_keys
sudo chown $USER:$USER $SSH_DIR/authorized_keys

# Step 3: Update SSH config
sudo sed -i 's/^#PasswordAuthentication.*/PasswordAuthentication no/' /etc/ssh/sshd_config
sudo sed -i 's/^#PubkeyAuthentication.*/PubkeyAuthentication yes/' /etc/ssh/sshd_config

# Step 4: Restart SSH service (multi-distro)
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

echo "Key authentication configured for $USER."
./