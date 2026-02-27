#!/usr/bin/env bash
set -e

pkg install -y golang git debianutils make

tmp=$(mktemp -d)
trap "rm -rf '$tmp'" EXIT

cd "$tmp"
git clone https://github.com/cloudflare/cloudflared.git --depth=1
cd cloudflared
sed -i 's/linux/android/g' Makefile
CGO_ENABLED=0 make cloudflared
install cloudflared "$PREFIX/bin"
