#!/usr/bin/env bash

DEVICE_IP=$(
    ifconfig 2>/dev/null |
        awk '
            /^wlan[0-9]+:/ {
                wlan=1
                next
            }
            /^[^[:space:]]/ {
                wlan=0
            }
            wlan && /inet / {
                print $2
                exit
            }
        '
)

printf '%s\n' "${DEVICE_IP:-<device_ip>}"
