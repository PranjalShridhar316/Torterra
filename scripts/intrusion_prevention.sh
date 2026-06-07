#!/bin/bash
# Torterra v5 - Stable Intrusion Prevention System (Fail2Ban-style)

set -euo pipefail

# ----------------------------
# CONFIGURATION
# ----------------------------
THRESHOLD=5                          # failed attempts before blocking
declare -A IP_COUNT                 # associative array for tracking IPs

echo "[*] Torterra Intrusion Prevention System Starting..."

# ----------------------------
# DETECT LOG SOURCE
# ----------------------------
if [ -f /var/log/auth.log ]; then
    LOG="/var/log/auth.log"
    MODE="file"
elif [ -f /var/log/secure ]; then
    LOG="/var/log/secure"
    MODE="file"
else
    LOG=""
    MODE="journal"
fi

echo "[*] Mode detected: $MODE"

# ----------------------------
# BLOCK FUNCTION
# ----------------------------
block_ip() {
    local ip="$1"
    echo "[🚫] Blocking IP: $ip"

    # Firewall rule (works on most Linux systems)
    sudo iptables -A INPUT -s "$ip" -j DROP

    echo "[✔] IP blocked successfully"
}

# ----------------------------
# LOG STREAM FUNCTION
# ----------------------------
get_logs() {
    if [ "$MODE" = "file" ]; then
        sudo tail -F "$LOG"
    else
        # fallback for systemd systems
        sudo journalctl -f -t sshd
    fi
}

# ----------------------------
# MAIN LOOP
# ----------------------------
get_logs | while read -r line; do

    # Only process SSH-related security events
    echo "$line" | grep -Eq \
        "Failed password|Invalid user|authentication failure|Permission denied|Connection closed|Failed publickey|preauth"

    if [ $? -eq 0 ]; then

        # ----------------------------
        # SAFE IP EXTRACTION
        # ----------------------------
        ip=$(echo "$line" | grep -Eo '([0-9]{1,3}\.){3}[0-9]{1,3}' || true)

        # skip if no IP found
        if [ -z "$ip" ]; then
            continue
        fi

        # ----------------------------
        # SAFE COUNTER (FIX FOR UNBOUND VARIABLE)
        # ----------------------------
        IP_COUNT["$ip"]=$(( ${IP_COUNT["$ip"]:-0} + 1 ))

        echo "[*] $ip attempts: ${IP_COUNT[$ip]}"

        # ----------------------------
        # BLOCK IF THRESHOLD REACHED
        # ----------------------------
        if (( IP_COUNT["$ip"] >= THRESHOLD )); then
            block_ip "$ip"
            unset IP_COUNT["$ip"]
        fi
    fi

done