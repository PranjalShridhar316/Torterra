#!/bin/bash
# Torterra - Continuous Monitoring & Auditing Module (FINAL FIXED VERSION)

set -euo pipefail

# ----------------------------
# CONFIGURATION
# ----------------------------
AUDIT_DIR="$HOME/torterra_audit"
LOG_FILE="/var/log/auth.log"
REPORT_FILE="$AUDIT_DIR/daily_report.log"
LIVE_LOG="$AUDIT_DIR/live_audit.log"

mkdir -p "$AUDIT_DIR"

echo "[*] Torterra Continuous Audit System Started..."

# ----------------------------
# DETECT LOG SOURCE (MULTI-DISTRO)
# ----------------------------
if [ ! -f "$LOG_FILE" ]; then
    LOG_FILE="/var/log/secure"
fi

echo "[*] Using log file: $LOG_FILE"

# ----------------------------
# INITIAL SYSTEM SNAPSHOT
# ----------------------------
echo -e "\n===== TORTERRA SESSION START: $(date) =====\n" >> "$REPORT_FILE"

echo "[*] Checking system health..." >> "$REPORT_FILE"

# SSH STATUS CHECK (FIXED)
if systemctl status sshd >/dev/null 2>&1; then
    SSH_STATUS="sshd running"
elif systemctl status ssh >/dev/null 2>&1; then
    SSH_STATUS="ssh running"
else
    SSH_STATUS="unknown"
fi

echo "SSH Status: $SSH_STATUS" >> "$REPORT_FILE"

# FIREWALL CHECK
if command -v iptables >/dev/null 2>&1; then
    echo "Firewall: iptables available" >> "$REPORT_FILE"
else
    echo "Firewall: not found" >> "$REPORT_FILE"
fi

echo "-----------------------------" >> "$REPORT_FILE"

# ----------------------------
# REAL-TIME MONITORING LOOP (FIXED)
# ----------------------------
tail -F "$LOG_FILE" | while read -r line; do

    timestamp=$(date +"%Y-%m-%d %H:%M:%S")

    # ----------------------------
    # FILTER SSH SECURITY EVENTS
    # ----------------------------
    if echo "$line" | grep -Eq \
"sshd|Invalid user|invalid user|Failed password|Failed publickey|Connection closed|authentication failure|Permission denied|preauth"
    then

        # ----------------------------
        # SAFE IP EXTRACTION
        # ----------------------------
        ip=$(echo "$line" | grep -Eo '([0-9]{1,3}\.){3}[0-9]{1,3}' || true)

        # ----------------------------
        # 🔥 LIVE OUTPUT (FIX THAT WAS MISSING)
        # ----------------------------
        echo "[LIVE] $timestamp | $line"

        # ----------------------------
        # WRITE TO FILES
        # ----------------------------
        echo "[$timestamp] EVENT: $line" >> "$LIVE_LOG"
        echo "$timestamp | IP=${ip:-unknown} | $line" >> "$REPORT_FILE"

    fi

done