# Android Home Server

Turn a Termux Android device into a home server with SSH, file browser, and Cloudflare tunnel.

## Install

```bash
curl -fsSL https://raw.githubusercontent.com/namantam1/android-home-server/main/bootstrap.sh | bash
```

Sets up SSH, installs the `android-home` CLI, and configures auto-start on boot.

## Usage

```
Service management:
  setup <service|all>   Install a service
  enable <service>      Register with runit (auto-start on boot)
  disable <service>     Unregister from runit
  start <service>       sv start
  stop <service>        sv stop
  restart <service>     sv restart
  run <service>         Run in foreground (for debugging)
  logs <service>        Tail service logs

System:
  services              List services with install/enabled status
  status                Show running status
  ip                    Print LAN IP address
  info                  System summary (storage, battery, services)
  doctor                Run health checks

Data:
  backup [dest]         Archive config files
  restore <file>        Restore from backup

Other:
  completion            Enable bash tab completion
  update                Update to latest version
```

## Services

**`filebrowser`** — Web-based file manager at `http://<device-ip>:8080`

**`cloudflare-tunnel`** — Exposes local services to the internet.
Configure `~/.github-config` to auto-publish the tunnel URL on start:
```bash
cp ~/.android-home/.github-config.template ~/.github-config
nano ~/.github-config
```

## Structure

```
android-home          # CLI entry point
bootstrap.sh          # First-time setup
scripts/
  lib/                # Shared utilities (info, doctor, backup, restore, service, completion)
  filebrowser/        # build, setup, start
  cloudflare-tunnel/  # setup, start, tunnel URL updater
templates/            # runit service definitions
```

## Troubleshooting

See [troubleshoot.md](troubleshoot.md) for fixes to common Termux issues (signal 9, process killed, etc.).
