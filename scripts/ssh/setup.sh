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
echo "  ssh -p 8022 $(whoami)@$(bash "$(dirname "$0")/../lib/get-ip.sh")"
echo ""
