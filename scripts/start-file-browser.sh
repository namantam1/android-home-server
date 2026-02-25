#!/usr/bin/env bash

if ! command -v filebrowser &> /dev/null; then
    echo "FileBrowser not installed. Run: android-home setup file-browser"
    exit 1
fi

echo "Starting FileBrowser on http://0.0.0.0:8080"
echo "Access via: http://<device_ip>:8080"
filebrowser -r ~/storage --address 0.0.0.0 --port 8080
