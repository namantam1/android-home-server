#!/usr/bin/env bash
set -e

tmp=$(mktemp)
trap "rm -f '$tmp'" EXIT

curl -fsSL "https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-arm64" -o "$tmp"
chmod +x "$tmp"
"$tmp" --version
mv "$tmp" "$PREFIX/bin/cloudflared"
trap - EXIT
