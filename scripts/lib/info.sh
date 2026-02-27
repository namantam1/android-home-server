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
