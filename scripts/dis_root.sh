#!/bin/bash

# Script to disable root login in SSH 

SSHD_config="/etc/ssh/sshd_config"                                     # path to ssh configuration file

sudo cp $SSHD_config ${SSHD_config}.bak                                     # backup the original config file
sudo sed -i 's/^#PermitRootLogin.*/PermitRootLogin no/' $SSHD_config        # Disable root login

sudo systemctl restart sshd                                                 # Restart SSH service to apply changes

echo "ROOT LOGIN DISABLED"
