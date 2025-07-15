#!/bin/bash

set -e

# This script installs essential packages using the appropriate package manager for the OS.

# Function to setup Homebrew PATH
setup_homebrew_path() {
    if [[ $(uname -m) == "arm64" ]]; then
        # Apple Silicon Mac
        if ! grep -q "/opt/homebrew/bin" ~/.zprofile 2>/dev/null; then
            echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
        fi
        eval "$(/opt/homebrew/bin/brew shellenv)"
        export PATH="/opt/homebrew/bin:/opt/homebrew/sbin:$PATH"
    else
        # Intel Mac
        if ! grep -q "/usr/local/bin" ~/.zprofile 2>/dev/null; then
            echo 'export PATH="/usr/local/bin:/usr/local/sbin:$PATH"' >> ~/.zprofile
        fi
        export PATH="/usr/local/bin:/usr/local/sbin:$PATH"
    fi
}

# Detect OS and set package lists
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    # Linux
    if command -v pacman &> /dev/null; then
        # Arch Linux
        PACKAGE_MANAGER="yay"
        INSTALL_CMD="yay -S --needed"
        packages=(
            "gh"
            "ghq"
            "fzf"
            "ripgrep"
            "bat"
            "fd"
            "eza"
            "jq"
            "go-yq"
            "starship"
            "mise"
            "grc"
        )
    else
        echo "Unsupported Linux distribution. Please install packages manually."
        exit 1
    fi
elif [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS
    if command -v brew &> /dev/null; then
        PACKAGE_MANAGER="brew"
        INSTALL_CMD="brew install"
        packages=(
            "gh"
            "ghq"
            "fzf"
            "ripgrep"
            "bat"
            "fd"
            "eza"
            "jq"
            "yq"
            "starship"
            "mise"
            "grc"
        )
    else
        echo "Homebrew is not installed. Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        
        # Setup Homebrew PATH
        setup_homebrew_path
        
        # Verify brew is available
        if ! command -v brew &> /dev/null; then
            echo "Error: Homebrew installation failed or brew command not found in PATH"
            exit 1
        fi
        
        PACKAGE_MANAGER="brew"
        INSTALL_CMD="brew install"
        packages=(
            "gh"
            "ghq"
            "fzf"
            "ripgrep"
            "bat"
            "fd"
            "eza"
            "jq"
            "yq"
            "starship"
            "mise"
            "colima"
            "docker"
            "docker-compose"
            "grc"
        )
        echo "Homebrew installation completed."
    fi
else
    echo "Unsupported operating system: $OSTYPE"
    exit 1
fi

echo "Installing packages using $PACKAGE_MANAGER..."

# Install packages one by one to handle errors better
for package in "${packages[@]}"; do
    echo "Installing $package..."
    if $INSTALL_CMD "$package"; then
        echo "✓ $package installed successfully"
    else
        echo "✗ Failed to install $package"
        # Continue with other packages instead of exiting
    fi
done

echo "Package installation completed."
