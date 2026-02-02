@echo off
echo Prüfe SSH-Tunnel auf Port 1080...
netstat -ano | findstr "127.0.0.1:1080" | findstr "LISTENING"
if %errorlevel% equ 0 (
    echo [OK] Tunnel aktiv. Starte Chrome...
    start chrome.exe --proxy-server="socks5://127.0.0.1:1080" --host-resolver-rules="MAP * ~NOTFOUND , EXCLUDE localhost"
) else (
    echo [ERROR] SSH-Tunnel (NSSM) ist DOWN! Kill-Switch aktiv.
    pause
)
