#!/usr/bin/env bash

SCRIPTS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

ok()   { echo "  [✓] $1"; }
fail() { echo "  [✗] $1"; FAILED=1; }

FAILED=0

echo "System"
[[ -n "$PREFIX" ]]                          && ok "Termux environment"    || fail "Not running in Termux"
command -v svlogd &>/dev/null               && ok "termux-services"       || fail "termux-services not installed (pkg install termux-services)"
sv status sshd &>/dev/null 2>&1             && ok "runit supervisor"      || fail "runit not running"
[[ -f "$HOME/.termux/boot/start-sshd" ]]   && ok "boot script present"   || fail "boot script missing (~/.termux/boot/start-sshd)"
[[ -d "$HOME/storage" ]]                    && ok "storage mounted"       || fail "storage not mounted (run: termux-setup-storage)"

echo ""
echo "FileBrowser"
command -v filebrowser &>/dev/null          && ok "installed"             || fail "not installed (android-home setup filebrowser)"
[[ -d "$PREFIX/var/service/filebrowser" ]] && ok "runit enabled"         || fail "not enabled (android-home enable filebrowser)"

echo ""
echo "Cloudflare Tunnel"
command -v cloudflared &>/dev/null                    && ok "installed"             || fail "not installed (android-home setup cloudflare-tunnel)"
[[ -d "$PREFIX/var/service/cloudflare-tunnel" ]]     && ok "runit enabled"         || fail "not enabled (android-home enable cloudflare-tunnel)"
[[ -f "$HOME/.github-config" ]]                      && ok "~/.github-config found" || fail "~/.github-config missing"
if [[ -f "$HOME/.github-config" ]]; then
    grep -q "GITHUB_TOKEN=" "$HOME/.github-config"   && ok "GITHUB_TOKEN set"      || fail "GITHUB_TOKEN not set in ~/.github-config"
fi

echo ""
[[ $FAILED -eq 0 ]] && echo "All checks passed." || { echo "Some checks failed."; exit 1; }
