#!/usr/bin/env bash

echo "Checking service status..."
echo ""

echo ""
echo "FileBrowser:"
if command -v filebrowser &> /dev/null; then
    if pgrep -x filebrowser > /dev/null; then
        echo "  Status: running"
    else
        echo "  Status: installed but not running"
    fi
else
    echo "  Status: not installed"
fi

echo ""
echo "Cloudflared:"
if command -v cloudflared &> /dev/null; then
    if pgrep -x cloudflared > /dev/null; then
        echo "  Status: running"
    else
        echo "  Status: installed but not running"
    fi
else
    echo "  Status: not installed"
fi
