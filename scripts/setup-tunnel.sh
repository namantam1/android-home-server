#!/usr/bin/env bash
set -e

echo "Setting up Cloudflare Tunnel..."

pkg update -y >/dev/null 2>&1
pkg install -y golang git debianutils make >/dev/null 2>&1

echo "Downloading cloudflared..."
git clone https://github.com/cloudflare/cloudflared.git --depth=1 >/dev/null 2>&1
cd cloudflared || exit 1

sed -i 's/linux/android/g' Makefile

echo "Building cloudflared..."
export CGO_ENABLED=0
make cloudflared >/dev/null 2>&1
install cloudflared "$PREFIX/bin" >/dev/null 2>&1

cd ..
rm -rf cloudflared

cloudflared --version
echo "Cloudflared installed successfully"
echo "Run: android-home start tunnel"
