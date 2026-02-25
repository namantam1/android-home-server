#!/usr/bin/env bash
set -e

echo "Setting up SSH server..."

if [[ ! -f "$PREFIX/etc/ssh/sshd_config" ]]; then
    ssh-keygen -A
    echo "SSH server initialized"
fi

echo "Starting SSH..."
sshd

# Get IP addresses
echo ""
echo "SSH Server is running!"
echo ""
echo "Connection details:"
echo "  Username: $(whoami)"
echo "  Port: 8022"
echo ""
echo "To connect from your laptop on the same network:"
DEVICE_IP=$(hostname -I 2>/dev/null | awk '{print $1}' || ifconfig 2>/dev/null | grep 'inet ' | grep -v 127.0.0.1 | awk '{print $2}' | head -1)
if [[ -z "$DEVICE_IP" ]]; then
    echo "  Run 'ifconfig' to find your device IP"
    echo "  Then: ssh -p 8022 $(whoami)@<device_ip>"
else
    echo "  ssh -p 8022 $(whoami)@$DEVICE_IP"
fi
echo ""
echo "To find all device IPs:"
echo "  ifconfig"
