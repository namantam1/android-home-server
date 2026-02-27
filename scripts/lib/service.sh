#!/usr/bin/env bash

SERVICE_DIR="$PREFIX/var/service"
INSTALL_DIR="$HOME/.android-home"

_is_enabled() {
    [[ -d "$SERVICE_DIR/$1" ]]
}

enable_service() {
    local name="$1"
    local template="$INSTALL_DIR/templates/$name"
    if _is_enabled "$name"; then
        echo "$name already enabled"
        return
    fi
    [[ ! -d "$template" ]] && { echo "error: no template for $name" >&2; exit 1; }
    cp -r "$template" "$SERVICE_DIR/$name"
    chmod +x "$SERVICE_DIR/$name/run"
    [[ -d "$SERVICE_DIR/$name/log" ]] && \
        ln -sf "$PREFIX/share/termux-services/svlogger" "$SERVICE_DIR/$name/log/run" || true
    echo "$name enabled — run: sv start $name"
}

disable_service() {
    local name="$1"
    if ! _is_enabled "$name"; then
        echo "$name is not enabled"
        return
    fi
    sv stop "$name" 2>/dev/null || true
    rm -rf "$SERVICE_DIR/$name"
    echo "$name disabled"
}

export -f enable_service disable_service _is_enabled
