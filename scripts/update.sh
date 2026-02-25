#!/usr/bin/env bash
set -e

INSTALL_DIR="$HOME/.android-home"
REPO_URL="https://github.com/namantam1/android-home-server.git"

echo "Updating scripts..."

cd "$INSTALL_DIR"
git fetch origin
LOCAL=$(git rev-parse HEAD)
REMOTE=$(git rev-parse origin/main)

if [[ "$LOCAL" == "$REMOTE" ]]; then
    echo "Already up to date"
else
    git reset --hard origin/main >/dev/null 2>&1
    echo "Updated to latest version"
fi
