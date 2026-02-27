#!/usr/bin/env bash
set -e

source "$(dirname "$0")/../lib/setup-service.sh"
source "$(dirname "$0")/../lib/arch-config.sh"

if command -v filebrowser &>/dev/null || [[ -d "$PREFIX/var/service/file-browser" ]]; then
    echo "FileBrowser already installed"
    setup_service "file-browser"
    exit 0
fi

if [[ ! -d "$HOME/storage" ]]; then
    termux-setup-storage || true
    sleep 1
fi

echo "Setting up FileBrowser..."
try_install "$(dirname "$0")"
setup_service "file-browser"
echo "To start FileBrowser, run: sv start file-browser"
