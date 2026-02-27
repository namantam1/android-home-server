#!/usr/bin/env bash

ARCH_CONFIG_FILE="$HOME/.android-home-config"

load_arch_config() {
    [[ -f "$ARCH_CONFIG_FILE" ]] && source "$ARCH_CONFIG_FILE"
    CAN_USE_PREBUILT="${CAN_USE_PREBUILT:-unset}"
    export CAN_USE_PREBUILT ARCH_CONFIG_FILE
}

save_arch_config() {
    echo "CAN_USE_PREBUILT=$1" > "$ARCH_CONFIG_FILE"
}

try_install() {
    local service_dir="$1"
    load_arch_config

    if [[ "$CAN_USE_PREBUILT" != "false" ]]; then
        if bash "$service_dir/prebuilt.sh"; then
            save_arch_config true
            return 0
        fi
        echo "Pre-built binary failed, falling back to source build..."
        save_arch_config false
    fi

    bash "$service_dir/build.sh"
}

export -f load_arch_config save_arch_config try_install
