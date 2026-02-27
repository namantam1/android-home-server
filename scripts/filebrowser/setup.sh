#!/usr/bin/env bash
set -e

source "$(dirname "$0")/../lib/setup-service.sh"
source "$(dirname "$0")/../lib/arch-config.sh"

if command -v filebrowser &>/dev/null || [[ -d "$PREFIX/var/service/filebrowser" ]]; then
    echo "FileBrowser already installed"
    setup_service "filebrowser"
    exit 0
fi

if [[ ! -d "$HOME/storage" ]]; then
    echo "Initializing storage setup..."
    echo "Please give permission in phone!"
    termux-setup-storage || true
    sleep 1
fi

echo "Setting up FileBrowser..."
try_install "$(dirname "$0")"
setup_service "filebrowser"
echo "To start FileBrowser, run: sv start filebrowser"
