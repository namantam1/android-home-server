#!/usr/bin/env bash

DEVICE_IP=$(ip -4 addr show scope global 2>/dev/null \
    | awk '/inet /{print $2; exit}' \
    | cut -d/ -f1)

if [[ -z "$DEVICE_IP" ]]; then
    DEVICE_IP=$(ifconfig 2>/dev/null | awk '/inet / && $2 != "127.0.0.1" {print $2; exit}')
fi

printf '%s\n' "${DEVICE_IP:-<device_ip>}"

