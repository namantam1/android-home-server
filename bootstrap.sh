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

# Ensure password authentication is enabled so users can login with a UNIX password
SSHD_CONF="$PREFIX/etc/ssh/sshd_config"
if [[ -f "$SSHD_CONF" ]]; then
    if grep -q "^PasswordAuthentication" "$SSHD_CONF" 2>/dev/null; then
        sed -i 's/^PasswordAuthentication.*/PasswordAuthentication yes/' "$SSHD_CONF"
    else
        echo "PasswordAuthentication yes" >> "$SSHD_CONF"
    fi
fi

# Start sshd (ignore errors if already running)
sshd || true

# If a default password is provided via environment, try to set it non-interactively.
# Export a password before running bootstrap, e.g.:
#   ANDROID_HOME_DEFAULT_PASS='s3cret' bash bootstrap.sh
USER_NAME=$(whoami)
export ANDROID_HOME_DEFAULT_PASS='admin'
if [[ -n "$ANDROID_HOME_DEFAULT_PASS" ]]; then
    echo "Setting default password for user $USER_NAME"
    DEFAULT_PASS="$ANDROID_HOME_DEFAULT_PASS"
    # Prefer chpasswd if available
    if command -v chpasswd >/dev/null 2>&1; then
        echo "$USER_NAME:$DEFAULT_PASS" | chpasswd || echo "Warning: chpasswd failed"
    else
        # Try passwd via stdin if running on a tty
        if command -v passwd >/dev/null 2>&1 && [ -t 0 ]; then
            printf "%s\n%s\n" "$DEFAULT_PASS" "$DEFAULT_PASS" | passwd "$USER_NAME" || echo "Warning: passwd failed"
        else
            echo "Warning: cannot set password non-interactively on this system. Run 'passwd' to set it manually."
        fi
    fi
else
    # If running interactively, prompt the user to set their UNIX password used for SSH
    if [ -t 0 ]; then
        echo ""
        echo "Set your UNIX password (this will be used for SSH login):"
        passwd || true
    else
        echo "To set your SSH password later, run: passwd"
    fi
fi

echo ""
echo "Bootstrap complete!"
echo ""
echo "SSH Connection:"
echo "  ssh -p 8022 $(whoami)@$(bash "$INSTALL_DIR/scripts/get-ip.sh")"
echo ""
echo "Run 'android-home help' for available commands"

