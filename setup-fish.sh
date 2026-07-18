#!/bin/bash

set -euo pipefail

# Function to check if fisher is available
check_fisher() {
    if ! fish -c "type -q fisher" 2>/dev/null; then
        echo "⚠️ Fisher not found. Attempting installation..."
        # Use a more robust curl method for sourcing the installer
        fish -c "curl -sL https://git.io/fisher | source && fisher install jorgebucaran/fisher"
    fi
}

# Main execution function
main() {
    echo "=========================================="
    echo "Starting Fish Shell Plugin Setup..."
    echo "=========================================="

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
