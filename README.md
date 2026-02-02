# EUserv Oprekin Performance Analyzer & Multi-IP Manager

Dieses Projekt dient der Performance-Analyse beim Wechsel von EUserv SLA-Tarifen auf das 100Mbit Unmetered Beta-Profil und verwaltet das Multi-IP Setup.

## 🚀 Installation (Server)
1. Skript klonen: `git clone https://github.com`
2. Ausführbar machen: `chmod +x *.sh`
3. Analyzer starten: `./analyze.sh`

## 🛡️ Kill-Switch & Chrome Setup (Windows)
Um Datenlecks zu verhindern, starte Chrome NUR mit diesen Parametern:
`--proxy-server="socks5://127.0.0.1:1080" --host-resolver-rules="MAP * ~NOTFOUND , EXCLUDE localhost"`

### Firewall-Regeln:
1. **Block Rule:** Verbiete `chrome.exe` jeglichen ausgehenden Traffic.
2. **Allow Rule:** Erlaube `chrome.exe` Traffic nur zu Remote-IP `127.0.0.1`.

## 🌐 Multi-IP Konfiguration
Jede VM nutzt einen eigenen SSH-Tunnel-Port:
- **VM 1:** Port 1080 -> Ausgang IP 1
- **VM 2:** Port 1081 -> Ausgang IP 2 (via `setup-routing.sh`)

## 📊 Test-Ablauf
1. Starte `analyze.sh` -> Option 1 (Audit)
2. Starte Option 2 (Vorher-Test)
3. Bandbreite im EUserv Panel umstellen (Beta Profil)
4. 20 Min warten
5. Starte Option 3 (Nachher-Test)
