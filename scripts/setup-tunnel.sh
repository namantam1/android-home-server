#!/usr/bin/env bash
set -e

echo "Setting up Cloudflare Tunnel..."

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
echo "Run: android-home start tunnel"
