#!/usr/bin/env bash
set -e

echo "Installing cloudflared via pkg..."
if ! pkg install -y cloudflared 2>/dev/null; then
    echo ""
    echo "error: cloudflared not found in current package mirror." >&2
    echo "Switch to a mirror that carries it by running:" >&2
    echo ""
    echo "  termux-change-repo   (select 'All' repositories)"
    echo ""
    echo "Then re-run: android-home setup tunnel"
    exit 1
fi
