#!/bin/bash

set -euo pipefail

# Function to check if fisher is available
check_fisher() {
    if ! fish -c "type -q fisher" 2>/dev/null; then
        echo "⚠️ Fisher not found. Attempting installation..."
        fish -c "curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher"
    fi
}

# Make fish the login shell
set_default_shell() {
    local fish_path
    fish_path=$(command -v fish)

    if [[ "${SHELL:-}" == "$fish_path" ]]; then
        echo "✅ Default shell is already fish: $fish_path"
        return 0
    fi

    # chsh は /etc/shells に載っているシェルしか受け付けない
    if ! grep -qx "$fish_path" /etc/shells; then
        echo "$fish_path" | sudo tee -a /etc/shells > /dev/null
    fi

    echo "🐟 Changing default shell to $fish_path..."
    chsh -s "$fish_path"
}

# Main execution function
main() {
    echo "=========================================="
    echo "Starting Fish Shell Plugin Setup..."
    echo "=========================================="

    set_default_shell
    check_fisher

    echo "🚀 Updating all installed fish plugins via Fisher..."
    if ! fish -c "fisher update"; then
        echo "❌ Error: Failed to run 'fisher update'. Check your network or fisher installation." >&2
        return 1
    fi

    echo ""
    echo "✅ Fish plugin setup completed successfully."
}

main
