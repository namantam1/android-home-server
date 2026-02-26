#!/usr/bin/env bash
set -e

echo "Setting up FileBrowser..."

# skip if already installed (binary or service present)
if command -v filebrowser &> /dev/null || [[ -d "$PREFIX/var/service/file-browser" ]]; then
    echo "FileBrowser already installed, skipping setup"
    # still update service
    setup_service "file-browser"
    exit 0
fi

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
# determine version information for embedding
GIT_COMMIT=$(git rev-parse --short HEAD || echo "")
VERSION=$(git describe --tags --abbrev=0 2>/dev/null || echo "")

CGO_ENABLED=0 go build -ldflags='-s -w \
    -X "github.com/filebrowser/filebrowser/v2/version.Version=${VERSION}" \
    -X "github.com/filebrowser/filebrowser/v2/version.CommitSHA=${GIT_COMMIT}"' \
    -tags embed -o filebrowser

mv -f filebrowser "$PREFIX/bin/"
chmod +x "$PREFIX/bin/filebrowser"

cd
rm -rf "$TEMP_DIR"

echo "FileBrowser installed successfully"

# Setup service template
source "$(dirname "$0")/../lib/setup-service.sh"
setup_service "file-browser"
echo "To start FileBrowser, run: sv start file-browser"
