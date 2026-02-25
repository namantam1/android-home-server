# Android Home Server

Setup script and CLI tools to turn an Android device with Termux into a home server. Includes SSH access, file browser, and Cloudflare tunnel support.

## Quick Start

On your Android device with Termux installed:

```bash
curl -fsSL https://raw.githubusercontent.com/namantam1/android-home-server/main/bootstrap.sh | bash
```

This will:
- Update packages
- Install SSH, git, and termux-services
- Setup storage access
- Install the `android-home` CLI tool
- Configure auto-start SSH on boot

## Available Commands

```bash
# Setup commands (install services)
android-home setup ssh              # Setup SSH server
android-home setup file-browser     # Setup FileBrowser
android-home setup tunnel           # Setup Cloudflare tunnel
android-home setup all              # Setup all services

# Start commands (run services)
android-home start ssh              # Start SSH server
android-home start file-browser     # Start FileBrowser
android-home start tunnel           # Start Cloudflare tunnel

# Other commands
android-home status                 # Show service status
android-home update                 # Update to latest version
android-home help                   # Show help
```

## Services

### SSH Server

Provides remote terminal access over the network.

```bash
android-home setup ssh
android-home start ssh
```

Connect from your laptop:
```bash
ssh -p 8022 user@<device_ip>
```

Find your device IP:
```bash
ifconfig
```

### FileBrowser

Web-based file manager and storage server.

```bash
android-home setup file-browser
android-home start file-browser
```

Access via: `http://<device_ip>:8080`

### Cloudflare Tunnel

Expose your services securely to the internet.

```bash
android-home setup tunnel
android-home start tunnel 8080  # Expose FileBrowser
```

## Manual Installation

If bootstrap doesn't work, install manually:

1. Clone the repository:
```bash
git clone https://github.com/namantam1/android-home-server.git ~/.android-home
cd ~/.android-home
```

2. Make scripts executable:
```bash
chmod +x bootstrap.sh scripts/*.sh
```

3. Run bootstrap:
```bash
bash bootstrap.sh
```

## Structure

```
scripts/
  setup-ssh.sh           # SSH server setup
  setup-file-browser.sh  # FileBrowser build and install
  setup-tunnel.sh        # Cloudflare tunnel setup
  start-ssh.sh          # Start SSH
  start-file-browser.sh # Start FileBrowser
  start-tunnel.sh       # Start Cloudflare tunnel
  status.sh             # Show service status
  update.sh             # Update scripts
bootstrap.sh            # Bootstrap script for first run
```

## Notes

- SSH auto-starts on boot via `~/.termux/boot/start-sshd`
- Services run in foreground; use tmux/screen for background execution
- FileBrowser stores files in `~/storage`
- Cloudflare tunnel requires internet connection
