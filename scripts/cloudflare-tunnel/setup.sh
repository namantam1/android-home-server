#!/usr/bin/env bash
set -e

source "$(dirname "$0")/../lib/setup-service.sh"
source "$(dirname "$0")/../lib/arch-config.sh"

if command -v cloudflared &>/dev/null || [[ -d "$PREFIX/var/service/cloudflare-tunnel" ]]; then
    echo "Cloudflared already installed"
    setup_service "cloudflare-tunnel"
    exit 0
fi

echo "Setting up Cloudflare Tunnel..."
try_install "$(dirname "$0")"
cloudflared --version
setup_service "cloudflare-tunnel"
echo "To start the tunnel, run: sv start cloudflare-tunnel"
