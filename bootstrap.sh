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
cat > "$CLI_SCRIPT" << 'EOF'
#!/usr/bin/env bash
INSTALL_DIR="$HOME/.android-home"
SCRIPTS_DIR="$INSTALL_DIR/scripts"

case "$1" in
    setup)
        bash "$SCRIPTS_DIR/setup-${2}.sh" "${@:3}"
        ;;
    start)
        bash "$SCRIPTS_DIR/start-${2}.sh" "${@:3}"
        ;;
    status)
        bash "$SCRIPTS_DIR/status.sh"
        ;;
    update)
        bash "$SCRIPTS_DIR/update.sh"
        ;;
    help|--help|-h|"")
        cat << HELP
Usage: android-home <command> [options]

Commands:
  setup <service>    Setup a service (ssh, file-browser, tunnel, all)
  start <service>    Start a service (ssh, file-browser, tunnel)
  status             Show service status
  update             Update to latest version
  help               Show this help message

Examples:
  android-home setup ssh
  android-home start file-browser
  android-home update

HELP
        ;;
    *)
        echo "Unknown command: $1"
        echo "Run 'android-home help' for usage"
        exit 1
        ;;
esac
EOF
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

echo "Bootstrap complete!"
echo "Run 'android-home help' for available commands"

