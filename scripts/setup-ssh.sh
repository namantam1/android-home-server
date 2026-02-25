#!/usr/bin/env bash
set -e

echo "Setting up SSH server..."

if [[ ! -f "$PREFIX/etc/ssh/sshd_config" ]]; then
    ssh-keygen -A >/dev/null 2>&1
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
echo "  ssh -p 8022 $(whoami)@<device_ip>"
echo ""
echo "To find your device IP:"
echo "  ifconfig"
