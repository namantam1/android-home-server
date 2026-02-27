#!/usr/bin/env bash
set -e

tmp=$(mktemp -d)
trap "rm -rf '$tmp'" EXIT

curl -fsSL "https://github.com/filebrowser/filebrowser/releases/latest/download/linux-arm64-filebrowser.tar.gz" \
    -o "$tmp/fb.tar.gz"
tar -xzf "$tmp/fb.tar.gz" -C "$tmp"
chmod +x "$tmp/filebrowser"
"$tmp/filebrowser" version
mv "$tmp/filebrowser" "$PREFIX/bin/filebrowser"
