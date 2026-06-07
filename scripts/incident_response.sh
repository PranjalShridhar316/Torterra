#!/bin/bash
# Torterra - Incident Response & Recovery Module

set -euo pipefail

INCIDENT_DIR="$HOME/torterra_incidents"
mkdir -p "$INCIDENT_DIR"

echo "[*] Incident Response System Active..."

# Watch auth logs (multi-distro support can be added later)
LOG_FILE="/var/log/auth.log"
if [ ! -f "$LOG_FILE" ]; then
    LOG_FILE="/var/log/secure"
fi

tail -F "$LOG_FILE" | while read -r line; do

    # Detect security incidents
    if echo "$line" | grep -Eq "Failed password|Invalid user|Connection closed|Permission denied|authentication failure"; then

        ip=$(echo "$line" | grep -Eo '([0-9]{1,3}\.){3}[0-9]{1,3}' || true)
        user=$(echo "$line" | awk '{for(i=1;i<=NF;i++) if($i=="user") print $(i+1)}')

        timestamp=$(date +"%Y-%m-%d_%H-%M-%S")

        # Create incident file
        INCIDENT_FILE="$INCIDENT_DIR/incident_$timestamp.txt"

        {
            echo "===== TORTERRA INCIDENT REPORT ====="
            echo "Time: $timestamp"
            echo "Raw Log: $line"
            echo "Detected IP: ${ip:-unknown}"
            echo "User: ${user:-unknown}"
            echo "------------------------------------"
        } > "$INCIDENT_FILE"

        echo "[🚨] Incident recorded: $INCIDENT_FILE"

    fi

done