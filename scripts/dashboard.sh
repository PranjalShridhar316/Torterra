#!/bin/bash
# TORTERRA - SOC Agent Control System (Persistent Infinite Mode)

set -euo pipefail

# ----------------------------
# CONFIG (ONE TIME SETUP)
# ----------------------------
CONFIG_FILE="$HOME/.torterra_config"

USERNAME=""
LABEL=""

# ----------------------------
# BOOTSTRAP (RUN ONCE)
# ----------------------------
bootstrap() {
    if [ -f "$CONFIG_FILE" ]; then
        source "$CONFIG_FILE"
        echo "[*] Welcome back, $USERNAME"
        return
    fi

    clear
    echo "━━━━━━━━ TORTERRA FIRST-TIME SETUP ━━━━━━━━"
    read -rp "Enter username: " USERNAME
    read -rp "Enter system label: " LABEL

    cat <<EOF > "$CONFIG_FILE"
USERNAME=$USERNAME
LABEL=$LABEL
EOF

    echo "[*] Setup completed and saved."
    sleep 2
}

# ----------------------------
# RESET CREDENTIALS
# ----------------------------
reset_credentials() {
    echo "[*] Resetting credentials..."
    rm -f "$CONFIG_FILE"
    echo "[*] Credentials cleared. Restart script to reconfigure."
    exit 0
}

# ----------------------------
# BANNER
# ----------------------------
banner() {
cat << "EOF"

████████╗  ██████╗    ██████╗  ████████╗ ███████╗ ██████╗  ██████╗   █████╗ 
╚══██╔══╝ ██╔═══ ██╗  ██╔══██╗ ╚══██╔══╝ ██╔════╝ ██╔══██╗ ██╔══██╗ ██╔══██╗
   ██║   ██║      ██║ ██████╔╝    ██║    █████╗   ██████╔╝ ██████╔╝ ███████║
   ██║    ██║    ██║  ██╔══██╗    ██║    ██╔══╝   ██╔══██╗ ██╔══██╗ ██╔══██║
   ██║    ╚██████╔╝   ██║  ██║    ██║    ███████╗ ██║  ██║ ██║  ██║ ██║  ██║
   ╚═╝     ╚═════╝    ╚═╝  ╚═╝    ╚═╝    ╚══════╝ ╚═╝  ╚═╝ ╚═╝  ╚═╝ ╚═╝  ╚═╝

        🌿 TORTERRA SOC SECURITY AGENT
        🧠 "Set once. Run forever."

EOF
}

# ----------------------------
# SIMULATION MODE
# ----------------------------
simulation_mode() {
    echo "[*] Torterra Simulation Mode Starting..."
    echo "[*] Simulating attack patterns..."

    for i in {1..5}; do
        echo "[SIM] Invalid user fake$i from 127.0.0.$i"
        sleep 1
    done

    echo "[*] Simulation complete."
    read -rp "Press Enter to continue..."
}

# ----------------------------
# INFINITE MODE (REAL MONITOR)
# ----------------------------
infinite_mode() {
    echo "[*] Starting Infinite SOC Monitoring..."
    echo "[*] Press CTRL+C to stop"

    LOG_FILE="/var/log/auth.log"
    [ ! -f "$LOG_FILE" ] && LOG_FILE="/var/log/secure"

    tail -F "$LOG_FILE" | while read -r line; do
        echo "[SOC] $line"
    done
}

# ----------------------------
# MENU
# ----------------------------
menu() {
    clear
    banner

    echo "User : ${USERNAME:-unknown}"
    echo "Label: ${LABEL:-none}"
    echo ""
    echo "1) Simulation Mode"
    echo "2) Infinite SOC Mode"
    echo "3) Reset Credentials"
    echo "4) Exit"
    echo ""

    read -rp "Select option: " opt
    opt=$(echo "$opt" | awk '{print $1}')
}

# ----------------------------
# INIT
# ----------------------------
bootstrap

# ----------------------------
# MAIN LOOP
# ----------------------------
while true; do
    menu

    case "$opt" in
        1) simulation_mode ;;
        2) infinite_mode ;;
        3) reset_credentials ;;
        4) echo "[*] Exiting Torterra..."; exit 0 ;;
        *) echo "Invalid option"; sleep 1 ;;
    esac
done