#!/usr/bin/env bash
set -e

INSTALL_DIR="$HOME/.android-home"
REPO_URL="https://github.com/namantam1/android-home-server.git"

echo "Updating scripts..."

cd "$INSTALL_DIR"
git fetch origin
LOCAL=$(git rev-parse HEAD)
REMOTE=$(git rev-parse origin/main)

if [[ "$LOCAL" == "$REMOTE" ]]; then
    echo "Already up to date"
else
    git reset --hard origin/main >/dev/null 2>&1
    echo "Updated to latest version"
fi

# After pulling the latest code, re-run setup for any services that have
# already been installed under $PREFIX/var/service. This ensures templates and
# binaries managed by this repository are refreshed when the repo is updated.
echo "Checking for installed services to update..."
if [[ -d "$INSTALL_DIR/templates" ]]; then
    for tmpl in "$INSTALL_DIR"/templates/*; do
        svc=$(basename "$tmpl")
        # service directory exists and we have a corresponding setup script
        if [[ -d "$PREFIX/var/service/$svc" ]] && [[ -x "$INSTALL_DIR/scripts/$svc/setup.sh" ]]; then
            echo "- Updating service '$svc'"
            # run the setup script; don't abort the entire update if one fails
            bash "$INSTALL_DIR/scripts/$svc/setup.sh" || \
                echo "  Warning: update for service '$svc' failed"
        fi
    done
else
    echo "No service templates found, skipping service updates"
fi
