#!/usr/bin/env bash

SCRIPTS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "IP:      $("$SCRIPTS_DIR/get-ip.sh")"
echo "Uptime:  $(uptime -p 2>/dev/null || uptime)"

# Storage
storage_line=$(df -h "$HOME" 2>/dev/null | tail -1)
used=$(echo "$storage_line" | awk '{print $3}')
total=$(echo "$storage_line" | awk '{print $2}')
echo "Storage: $used used / $total total"

# Battery (termux-battery-status returns JSON)
if command -v termux-battery-status &>/dev/null; then
    bat=$(termux-battery-status 2>/dev/null)
    pct=$(echo "$bat"  | grep -o '"percentage":[^,}]*' | grep -o '[0-9]*')
    sta=$(echo "$bat"  | grep -o '"status":"[^"]*"'    | sed 's/.*":"\(.*\)"/\1/')
    echo "Battery: ${pct}% ($sta)"
fi

echo ""

# Service status with port
svc_status() {
    local name="$1" bin="$2" port="$3"
    if command -v "$bin" &>/dev/null; then
        if pgrep -x "$bin" &>/dev/null; then
            echo "  $name     running  :$port"
        else
            echo "  $name     stopped"
        fi
    else
        echo "  $name     not installed"
    fi
}

svc_status "filebrowser    " filebrowser 8080
svc_status "cloudflare-tunnel" cloudflared ""

# Tunnel URL if cloudflared running
if pgrep -x cloudflared &>/dev/null; then
    url=$(curl -s "http://127.0.0.1:4040/metrics" \
        | sed -n 's/.*userHostname="\([^"]*\)".*/\1/p' | head -1)
    [[ -n "$url" ]] && echo "  tunnel-url       https://$url"
fi
