#!/usr/bin/env bash
set -e

dest="${1:-$HOME/android-home-backup-$(date +%Y%m%d-%H%M%S).tar.gz}"

files=()
add() { [[ -e "$1" ]] && files+=("$1") || true; }

add "$HOME/.github-config"
add "$HOME/.android-home-config"
add "$HOME/.termux/boot"
# FileBrowser database
fb_db=$(find "$HOME" -maxdepth 4 -name "filebrowser.db" 2>/dev/null | head -1)
add "$fb_db"

echo "Backing up:"
for f in "${files[@]}"; do echo "  $f"; done

tar -czf "$dest" "${files[@]/#/$HOME/}" 2>/dev/null || \
    tar -czf "$dest" "${files[@]}"

echo "Saved: $dest"
