#!/usr/bin/env bash

if ! command -v cloudflared &> /dev/null; then
    echo "Cloudflared not installed. Run: android-home setup tunnel"
    exit 1
fi

PORT=${1:-8080}
echo "Starting Cloudflare tunnel for localhost:$PORT"
cloudflared tunnel --url localhost:$PORT
