#!/bin/bash
# Torterra v4 - Robust multi-distro SSH login monitor (fixed + complete coverage)

set -euo pipefail

# Output log file
OUTPUT="$HOME/failed_attempts.log"

# Log startup time
echo "----- Torterra Monitor Started: $(date) -----" >> "$OUTPUT"

echo "[*] Detecting system log source..."

# Detect log source (Debian / RHEL / systemd fallback)
if [ -f /var/log/auth.log ]; then
    MODE="file"
    LOG="/var/log/auth.log"
elif [ -f /var/log/secure ]; then
    MODE="file"
    LOG="/var/log/secure"
else
    MODE="journal"
fi

echo "[*] Mode detected: $MODE"

# ----------------------------
# PARSER (FIXED + COMPLETE)
# ----------------------------
parse() {
awk '
{
    ts=$1" "$2" "$3;
    user="unknown";
    ip="unknown";

    # -------------------------
    # Invalid user attempts
    # -------------------------
    if ($0 ~ /Invalid user/) {
        match($0, /Invalid user ([^ ]+)/, u);
        match($0, /from ([0-9a-fA-F\.:]+)/, a);
        user=u[1]; ip=a[1];
    }

    # -------------------------
    # Password failures
    # -------------------------
    else if ($0 ~ /Failed password/) {
        match($0, /for (invalid user )?([^ ]+)/, u);
        match($0, /from ([0-9a-fA-F\.:]+)/, a);
        user=u[2]; ip=a[1];
    }

    # -------------------------
    # PAM / authentication failure
    # -------------------------
    else if ($0 ~ /authentication failure/) {
        match($0, /user=([^ ]+)/, u);
        match($0, /rhost=([0-9a-fA-F\.:]+)/, a);
        user=u[1]; ip=a[1];
    }

    # -------------------------
    # Public key failures
    # -------------------------
    else if ($0 ~ /Failed publickey/) {
        match($0, /for ([^ ]+)/, u);
        match($0, /from ([0-9a-fA-F\.:]+)/, a);
        user=u[1]; ip=a[1];
    }

    # -------------------------
    # Permission denied (modern SSH)
    # -------------------------
    else if ($0 ~ /Permission denied/) {
        match($0, /for ([^ ]+)/, u);
        match($0, /from ([0-9a-fA-F\.:]+)/, a);
        user=u[1]; ip=a[1];
    }

    # -------------------------
    # Connection closed attempts
    # -------------------------
    else if ($0 ~ /Connection closed by authenticating user/) {
        match($0, /user ([^ ]+)/, u);
        match($0, /([0-9]+\.[0-9]+\.[0-9]+\.[0-9]+)/, a);
        user=u[1]; ip=a[1];
    }

    # -------------------------
    # OUTPUT ONLY VALID ENTRIES
    # -------------------------
    if (ip != "unknown" && ip != "") {
        print ts " user=" user " ip=" ip
    }
}'
}

# ----------------------------
# LOG STREAM (FIXED)
# ----------------------------
if [ "$MODE" = "file" ]; then
    sudo stdbuf -oL tail -F "$LOG"
else
    sudo stdbuf -oL journalctl -f -t sshd
fi | stdbuf -oL bash -c "$(declare -f parse); parse" | tee -a "$OUTPUT"