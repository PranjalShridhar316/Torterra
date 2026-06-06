#!/bin/bash
# Multi-distro failed login monitoring

set -e

# Detect distribution
if [ -f /etc/os-release ]; then
    . /etc/os-release
    DISTRO=$ID
else
    echo "Cannot detect distribution."
    exit 1
fi

# Pick correct log file based on distro
case "$DISTRO" in
    debian|ubuntu|arch)
        LOG_FILE="/var/log/auth.log"
        ;;
    rhel|centos|fedora)
        LOG_FILE="/var/log/secure"
        ;;
    *)
        echo "Unsupported distribution: $DISTRO"
        exit 1
        ;;
esac

OUTPUT_FILE="/var/log/failed_attempts.log"

# Write header
echo "Failed login attempts:" | sudo tee $OUTPUT_FILE > /dev/null

# Extract failed login attempts
sudo grep "Failed password" $LOG_FILE | awk '{print $1,$2,$3,$11}' | sudo tee -a $OUTPUT_FILE > /dev/null

echo "Results saved to $OUTPUT_FILE"
