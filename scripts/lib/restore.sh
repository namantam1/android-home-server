#!/usr/bin/env bash
set -e

archive="${1:?'Usage: android-home restore <backup-file>'}"
[[ ! -f "$archive" ]] && { echo "error: file not found: $archive" >&2; exit 1; }

echo "Restoring from $archive..."
tar -tzf "$archive"

read -r -p "Proceed? This will overwrite existing files. [y/N] " ans
[[ "$ans" =~ ^[Yy]$ ]] || { echo "Aborted."; exit 0; }

tar -xzf "$archive" -C /
echo "Restore complete."
