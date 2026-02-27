#!/usr/bin/env bash
set -e

pkg install -y git golang nodejs-lts
npm install -g pnpm

tmp=$(mktemp -d)
trap "rm -rf '$tmp'" EXIT

cd "$tmp"
git clone https://github.com/filebrowser/filebrowser.git
cd filebrowser
git checkout "$(git describe --tags "$(git rev-list --tags --max-count=1)")"

NODE_OPTIONS=--max-old-space-size=4096 pnpm --prefix frontend install
NODE_OPTIONS=--max-old-space-size=4096 pnpm --prefix frontend build --minify=false --sourcemap=false

CGO_ENABLED=0 go build -tags embed -o filebrowser
chmod +x filebrowser
mv filebrowser "$PREFIX/bin/filebrowser"
