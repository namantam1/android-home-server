#!/usr/bin/env bash
# Android Home Server - Bootstrap Script

set -e

REPO_URL="https://github.com/namantam1/android-home-server.git"
INSTALL_DIR="$HOME/.android-home"
CLI_SCRIPT="$PREFIX/bin/android-home"
BOOT_DIR="$HOME/.termux/boot"

if [[ ! -d "$PREFIX" ]]; then
    echo "Error: This script must be run on Termux"
    exit 1
fi

echo "Updating packages..."
pkg update -y >/dev/null 2>&1 || true
pkg upgrade -y >/dev/null 2>&1 || true

echo "Installing dependencies..."
pkg install -y git openssh termux-services >/dev/null 2>&1

echo "Setting up storage..."
if [[ ! -d "$HOME/storage" ]]; then
    termux-setup-storage >/dev/null 2>&1 || true
    sleep 1
fi

mkdir -p "$INSTALL_DIR"

echo "Downloading repository..."
if [[ -d "$INSTALL_DIR/.git" ]]; then
    cd "$INSTALL_DIR"
    git fetch origin >/dev/null 2>&1
    git reset --hard origin/main >/dev/null 2>&1
else
    git clone "$REPO_URL" "$INSTALL_DIR" >/dev/null 2>&1
fi

echo "Installing CLI tool..."
ln -sf "$INSTALL_DIR/android-home" "$CLI_SCRIPT" || cp "$INSTALL_DIR/android-home" "$CLI_SCRIPT"
chmod +x "$CLI_SCRIPT"
echo "CLI tool installed"

mkdir -p "$BOOT_DIR"
cat > "$BOOT_DIR/start-sshd" << 'EOF'
#!/data/data/com.termux/files/usr/bin/sh
termux-wake-lock
sshd
EOF
chmod +x "$BOOT_DIR/start-sshd"

echo "Initializing SSH..."
if [[ ! -f "$PREFIX/etc/ssh/sshd_config" ]]; then
    ssh-keygen -A >/dev/null 2>&1
fi

sshd 2>/dev/null || true

echo ""
echo "Bootstrap complete!"
echo ""
echo "SSH Connection:"
DEVICE_IP=$(hostname -I 2>/dev/null | awk '{print $1}' || echo "YOUR_DEVICE_IP")
if [[ "$DEVICE_IP" == "YOUR_DEVICE_IP" ]]; then
    echo "  Run 'ifconfig' to find your device IP"
    echo "  Then: ssh -p 8022 $(whoami)@<device_ip>"
else
    echo "  ssh -p 8022 $(whoami)@$DEVICE_IP"
fi
echo ""
echo "Run 'android-home help' for available commands"

