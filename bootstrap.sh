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
pkg update -y || true
pkg upgrade -y || true

echo "Installing dependencies..."
pkg install -y git openssh termux-services

echo "Setting up storage..."
if [[ ! -d "$HOME/storage" ]]; then
    termux-setup-storage || true
    sleep 1
fi

mkdir -p "$INSTALL_DIR"

echo "Downloading repository..."
if [[ -d "$INSTALL_DIR/.git" ]]; then
    cd "$INSTALL_DIR"
    git fetch origin
    git reset --hard origin/main
else
    git clone "$REPO_URL" "$INSTALL_DIR"
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
    ssh-keygen -A
fi

sshd || true

echo ""
echo "Bootstrap complete!"
echo ""
echo "Set the UNIX password for SSH login, run:"
echo "  passwd"
echo ""
echo "SSH Connection:"
echo "  ssh -p 8022 $(whoami)@$(bash "$INSTALL_DIR/scripts/get-ip.sh")"
echo ""
echo "Run 'android-home help' for available commands"

