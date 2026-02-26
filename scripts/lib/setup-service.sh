#!/usr/bin/env bash

# Setup service template
# Usage: setup_service <service_name>
# This function copies the service template from templates/<service_name> to $PREFIX/var/service/<service_name>
# and creates a symlink for the logger

setup_service() {
    local service_name="$1"
    
    if [[ -z "$service_name" ]]; then
        echo "Error: Service name is required"
        return 1
    fi
    
    local script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
    local service_template="$script_dir/templates/$service_name"
    local service_dir="$PREFIX/var/service/$service_name"
    
    if [[ ! -d "$service_template" ]]; then
        echo "Warning: Service template not found at $service_template"
        return 1
    fi
    
    echo "Setting up service template..."
    mkdir -p "$PREFIX/var/service"
    cp -r "$service_template" "$service_dir"
    chmod +x "$service_dir/run"
    
    # Create symlink for logger in log directory
    if [[ -d "$service_dir/log" ]]; then
        ln -sf "$PREFIX/share/termux-services/svlogger" "$service_dir/log/run" || true
    fi
    
    echo "Service installed at $service_dir"
    echo "Run: sv start $service_name"
    
    return 0
}

# Export function for use in other scripts
export -f setup_service
