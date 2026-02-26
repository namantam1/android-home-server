#!/usr/bin/env bash

if ! command -v cloudflared &> /dev/null; then
    echo "Cloudflared not installed. Run: android-home setup tunnel"
    exit 1
fi

PORT=${1:-8080}
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "Starting Cloudflare tunnel for localhost:$PORT"

# Run update-gh-page.sh in the background after the tunnel is up.
# It blocks internally until the tunnel URL is available, then exits.
"$SCRIPT_DIR/update-gh-page.sh" &

exec cloudflared tunnel --url localhost:$PORT --metrics "127.0.0.1:4040"
