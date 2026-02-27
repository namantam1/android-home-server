# Android Home Server

Turn a Termux Android device into a home server with SSH, file browser, and Cloudflare tunnel.

## Install

```bash
curl -fsSL https://raw.githubusercontent.com/namantam1/android-home-server/main/bootstrap.sh | bash
```

Sets up SSH, installs the `android-home` CLI, and configures auto-start on boot.

## Usage

```bash
android-home setup <service>   # Install a service
android-home start <service>   # Start a service
android-home services          # List services with install status
android-home status            # Show running status
android-home completion        # Enable bash tab completion
android-home update            # Update to latest version
```

## Services

**`filebrowser`** — Web-based file manager, accessible at `http://<device-ip>:8080`

**`cloudflare-tunnel`** — Exposes local services to the internet over a secure tunnel.
After setup, configure `~/.github-config` to auto-publish the tunnel URL:
```bash
cp ~/.android-home/.github-config.template ~/.github-config
nano ~/.github-config
```
Then start: `android-home start cloudflare-tunnel 8080`

## Structure

```
android-home          # CLI entry point
bootstrap.sh          # First-time setup
scripts/
  lib/                # Shared utilities and helpers
  filebrowser/        # Build, setup, start
  cloudflare-tunnel/  # Setup, start, tunnel URL updater
templates/            # runit service definitions
```

## Troubleshooting

See [troubleshoot.md](troubleshoot.md) for fixes to common Termux issues (process killed, signal 9, etc.).
