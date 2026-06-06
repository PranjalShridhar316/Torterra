#!/bin/bash
# Script to enforce SSH key authentication and disable password login

USER=$1                               # Take username as argument (e.g., ./setup_keys.sh inoske)
SSH_DIR="/home/$USER/.ssh"            # Path to user's SSH directory


sudo mkdir -p $SSH_DIR
sudo chmod 700 $SSH_DIR               # Secure directory permissions (only user can access)


# Assumes you already generated a key with: ssh-keygen -t ed25519
sudo cat ~/.ssh/id_ed25519.pub | sudo tee -a $SSH_DIR/authorized_keys > /dev/null
sudo chmod 600 $SSH_DIR/authorized_keys   # Secure file permissions

# Update SSH config to disable password login and enforce key authentication
sudo sed -i 's/^#PasswordAuthentication.*/PasswordAuthentication no/' /etc/ssh/sshd_config
sudo sed -i 's/^#PubkeyAuthentication.*/PubkeyAuthentication yes/' /etc/ssh/sshd_config

#Restart SSH service to apply changes
sudo systemctl restart sshd

echo "Key authentication configured for $USER."
