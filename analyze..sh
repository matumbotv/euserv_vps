#!/bin/bash
# EUserv Oprekin Performance & IP-Validator v2.5
# Zweck: System-Analyse und Bandbreiten-Vergleich (SLA vs. No-SLA)

LOG_DIR="./logs"
mkdir -p "$LOG_DIR"

# Abhängigkeiten prüfen
for tool in speedtest-cli curl iptables ip; do
    command -v $tool >/dev/null 2>&1 || { sudo apt update && sudo apt install -y $tool; }
done

show_menu() {
    clear
    echo "====================================================="
    echo "   EUSERV OPREKIN-SYSTEM ANALYZER (GitHub Version)"
    echo "====================================================="
    echo "1) SYSTEM-AUDIT (CPU, RAM, Disk, OS-Stats)"
    echo "2) VORHER-TEST (SLA-Profil: Speed & Latenz)"
    echo "3) NACHHER-TEST (Beta-Profil: Speed & Latenz)"
    echo "4) IP-ROUTING CHECK (Validierung IP1 vs. IP2)"
    echo "5) BEENDEN"
    echo "-----------------------------------------------------"
    read -p "Wähle eine Option [1-5]: " opt
}

run_audit() {
    TS=$(date +%Y%m%d_%H%M)
    LOG="$LOG_DIR/audit_$TS.log"
    {
        echo "--- HARDWARE & OS ---"
        uname -a && lscpu | grep "Model name"
        free -h && df -h
        echo "--- NETZWERK INTERFACES ---"
        ip -4 addr show eth0
        echo "--- OFFENE TUNNEL PORTS ---"
        ss -tulpen | grep LISTEN
    } | tee "$LOG"
    echo "Audit gespeichert unter $LOG"
}

run_speed() {
    MODE=$1
    TS=$(date +%Y%m%d_%H%M)
    LOG="$LOG_DIR/speed_${MODE}_$TS.log"
    echo "Starte Performance-Check: $MODE"
    {
        echo "Testzeit: $(date)"
        speedtest-cli --simple
        echo "EUserv Internal Download Test:"
        curl -o /dev/null -w "Speed: %{speed_download} B/s\n" http://speedcheck.vtn.euserv.org
    } | tee "$LOG"
}

while true; do
    show_menu
    case $opt in
        1) run_audit ;;
        2) run_speed "PRE_SLA" ;;
        3) run_speed "POST_BETA" ;;
        4) iptables -t nat -L POSTROUTING -v -n | grep "SNAT" || echo "Kein IP-Routing aktiv!";;
        5) exit 0 ;;
    esac
    read -p "Enter zum Zurückkehren..." dummy
done
