#!/usr/bin/env bash
set -e

echo "Setting up FileBrowser..."

echo "Setting up storage..."
if [[ ! -d "$HOME/storage" ]]; then
    termux-setup-storage || true
    sleep 1
fi

pkg update -y
pkg install -y git golang nodejs-lts

npm install -g pnpm

TEMP_DIR=$(mktemp -d)
cd "$TEMP_DIR" || exit 1

git clone https://github.com/filebrowser/filebrowser.git
cd filebrowser || exit 1

git checkout "$(git describe --tags $(git rev-list --tags --max-count=1))"

export NODE_OPTIONS=--max-old-space-size=4096

echo "Building frontend..."
cd frontend || exit 1
pnpm install
pnpm build --minify=false --sourcemap=false
cd ..

echo "Building binary..."
CGO_ENABLED=0 go build -tags embed -o filebrowser

mv -f filebrowser "$PREFIX/bin/"
chmod +x "$PREFIX/bin/filebrowser"

cd
rm -rf "$TEMP_DIR"

echo "FileBrowser installed successfully"
echo "Run: android-home start file-browser"
