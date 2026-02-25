#!/usr/bin/env bash
# Get device IP address from network interfaces

DEVICE_IP=$(hostname -I 2>/dev/null | awk '{print $1}' || ifconfig 2>/dev/null | grep 'inet ' | grep -v 127.0.0.1 | awk '{print $2}' | head -1)

if [[ -z "$DEVICE_IP" ]]; then
    echo "<device_ip>"
else
    echo "$DEVICE_IP"
fi
