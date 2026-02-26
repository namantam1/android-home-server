#!/usr/bin/env bash

echo "Checking service status..."
echo ""

echo "SSH:"
if pgrep -x sshd > /dev/null; then
    echo "  Status: running"
else
    echo "  Status: not running"
fi

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
