#!/usr/bin/env bash
set -e

echo "Setting up Cloudflare Tunnel..."

# skip if already installed (binary or service present)
if command -v cloudflared &> /dev/null || [[ -d "$PREFIX/var/service/cloudflare-tunnel" ]]; then
	echo "Cloudflared already installed, skipping build"
	# still update service template in case it changed
	source "$(dirname "$0")/../lib/setup-service.sh"
	setup_service "cloudflare-tunnel"
	exit 0
fi

pkg update -y
pkg install -y golang git debianutils make

echo "Downloading cloudflared..."
TEMP_DIR=$(mktemp -d)
cd "$TEMP_DIR" || exit 1

git clone https://github.com/cloudflare/cloudflared.git --depth=1
cd cloudflared || exit 1

sed -i 's/linux/android/g' Makefile

echo "Building cloudflared..."
export CGO_ENABLED=0
make cloudflared
install cloudflared "$PREFIX/bin"

cd
rm -rf "$TEMP_DIR"

cloudflared --version
echo "Cloudflared installed successfully"

# Setup service template
source "$(dirname "$0")/../lib/setup-service.sh"
setup_service "cloudflare-tunnel"
echo "To start the tunnel, run: sv start cloudflare-tunnel"
