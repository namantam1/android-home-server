#!/usr/bin/env bash
set -e

echo "Setting up FileBrowser..."

pkg update -y >/dev/null 2>&1
pkg install -y git golang nodejs-lts >/dev/null 2>&1

npm install -g pnpm >/dev/null 2>&1

cd "$HOME" || exit 1
rm -rf filebrowser

git clone https://github.com/filebrowser/filebrowser.git >/dev/null 2>&1
cd filebrowser || exit 1

git checkout "$(git describe --tags $(git rev-list --tags --max-count=1))" >/dev/null 2>&1

export NODE_OPTIONS=--max-old-space-size=4096

echo "Building frontend..."
cd frontend || exit 1
pnpm install >/dev/null 2>&1
pnpm build --minify=false --sourcemap=false >/dev/null 2>&1
cd ..

echo "Building binary..."
CGO_ENABLED=0 go build -tags embed -o filebrowser >/dev/null 2>&1

mv -f filebrowser "$PREFIX/bin/" >/dev/null 2>&1
chmod +x "$PREFIX/bin/filebrowser" >/dev/null 2>&1

echo "FileBrowser installed successfully"
echo "Run: android-home start file-browser"
