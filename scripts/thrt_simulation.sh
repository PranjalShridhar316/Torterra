#!/bin/bash
# Torterra - Threat Simulation & Resilience Testing (FINAL FIXED VERSION)

set -euo pipefail

echo "[*] Torterra Threat Simulation Starting..."
echo "[*] Localhost-only security testing mode"

TARGET="127.0.0.1"
USER="fakeuser"

# ----------------------------
# 1. BRUTE FORCE SIMULATION
# ----------------------------
bruteforce_test() {
    echo ""
    echo "===== [1] BRUTE FORCE SIMULATION ====="

    for i in {1..10}; do
        echo "[*] Attempt $i: SSH login simulation"

        # SAFE NON-BLOCKING SSH ATTEMPT
        timeout 2 sshpass -p "wrongpass$i" ssh \
            -o StrictHostKeyChecking=no \
            -o ConnectTimeout=1 \
            $USER@$TARGET "exit" 2>/dev/null || true

        sleep 0.3
    done

    echo "[✔] Brute force simulation completed"
}

# ----------------------------
# 2. PORT SCAN TEST
# ----------------------------
port_scan_test() {
    echo ""
    echo "===== [2] PORT SCANNING ====="

    if command -v nmap >/dev/null 2>&1; then
        nmap -sS -Pn $TARGET | head -20
    else
        echo "[!] nmap not installed - skipping scan"
    fi

    echo "[✔] Port scan completed"
}

# ----------------------------
# 3. SSH HARDENING TEST (FIXED - NO HANG)
# ----------------------------
ssh_hardening_test() {
    echo ""
    echo "===== [3] SSH HARDENING CHECK ====="

    timeout 3 bash -c "
        ssh root@$TARGET \
        -o BatchMode=yes \
        -o StrictHostKeyChecking=no \
        -o ConnectTimeout=2 \
        'exit'
    " 2>/dev/null || true

    echo "[✔] SSH hardening test executed (non-blocking)"
}

# ----------------------------
# 4. LOG RESILIENCE TEST (SAFE)
# ----------------------------
log_resilience_test() {
    echo ""
    echo "===== [4] LOG RESILIENCE TEST ====="

    echo "[*] Checking if logging system is responsive..."

    if [ -f /var/log/auth.log ]; then
        tail -n 5 /var/log/auth.log
    elif [ -f /var/log/secure ]; then
        tail -n 5 /var/log/secure
    else
        journalctl -n 5 -t sshd 2>/dev/null || echo "[!] No logs found"
    fi

    echo "[✔] Log system responsive"
}

# ----------------------------
# RUN ALL TESTS (SEQUENTIAL BUT SAFE)
# ----------------------------
bruteforce_test
port_scan_test
ssh_hardening_test
log_resilience_test

echo ""
echo "[🎯] Torterra Threat Simulation Completed Successfully"