#!/usr/bin/env bash

if ! command -v filebrowser &> /dev/null; then
    echo "FileBrowser not installed. Run: android-home setup filebrowser"
    exit 1
fi

mkdir -p "$HOME/.filebrowser"

echo "Starting FileBrowser on http://0.0.0.0:8080"
echo "Access via: http://$(bash "$(dirname "$0")/../lib/get-ip.sh"):8080"
exec filebrowser -r ~/storage/shared/server -d "$HOME/.filebrowser/filebrowser.db" --address 0.0.0.0 --port 8080
