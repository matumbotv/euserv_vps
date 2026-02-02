#!/bin/bash
# Setup für Multi-IP Routing (VM1=IP1, VM2=IP2)

# BITTE ANPASSEN:
IP_2="DEINE_ZWEITE_IP"
GW="DEIN_GATEWAY" # Findest du via 'ip route show'

echo "Konfiguriere Routing für IP: $IP_2"

# Tabelle erstellen
if ! grep -q "101 oprekin2" /etc/iproute2/rt_tables; then
    echo "101 oprekin2" >> /etc/iproute2/rt_tables
fi

# Regeln für Port 1081 (VM2)
iptables -t mangle -A OUTPUT -p tcp --sport 1081 -j MARK --set-mark 2
iptables -t nat -A POSTROUTING -m mark --mark 2 -j SNAT --to-source $IP_2
ip rule add fwmark 2 table oprekin2
ip route add default via $GW dev eth0 table oprekin2

echo "Setup abgeschlossen. Traffic über Port 1081 nutzt nun IP: $IP_2"
