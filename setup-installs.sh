#!/bin/bash

set -uo pipefail

# This script installs essential packages using the appropriate package manager for the OS.

# Function to setup Homebrew PATH
setup_homebrew_path() {
    if [[ $(uname -m) == "arm64" ]]; then
        # Apple Silicon Mac
        local brew_path="/opt/homebrew/bin"
        if ! grep -q "$brew_path" ~/.zprofile 2>/dev/null; then
            echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
        fi
        export PATH="$brew_path:$PATH"
    else
        # Intel Mac
        local brew_path="/usr/local/bin:/usr/local/sbin"
        if ! grep -q "$brew_path" ~/.zprofile 2>/dev/null; then
            echo "export PATH=\"$brew_path:$PATH\"" >> ~/.zprofile
        fi
        export PATH="$brew_path:$PATH"
    fi
}

# Detect OS and set package lists
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    # Linux (Assuming Arch/yay for this script's scope)
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
        "mise"
        "grc"
        "zoxide"
        "zellij"
        "ghostty"
        "nerd-fonts-hack-gen"
        "nerd-fonts-jetbrains-mono"
        "direnv"
        "docker"
        "docker-compose"
    )
elif [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS
    if ! command -v brew &> /dev/null; then
        echo "Homebrew is not installed. Attempting installation..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        setup_homebrew_path # Re-run path setup after potential brew install
        if ! command -v brew &> /dev/null; then
            echo "Error: Homebrew installation failed or 'brew' command not found in PATH." >&2
            exit 1
        fi
        echo "Homebrew setup complete. Please restart your shell for changes to take effect."
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
        "mise"
        "grc"
        "direnv"
    )
else
    echo "Error: Unsupported operating system: $OSTYPE" >&2
    exit 1
fi

echo "=========================================="
echo "Starting package installation using $PACKAGE_MANAGER..."
echo "=========================================="

# Install packages one by one to handle errors better
failed_packages=()
success_count=0
total_count=${#packages[@]}

for package in "${packages[@]}"; do
    if command -v "$package" &>/dev/null; then
        echo "✅ Already installed: $package"
        ((success_count++))
        continue
    fi
    
    echo -n "📦 Installing $package... "
    # Use eval to correctly execute the install command with package names
    if eval "$INSTALL_CMD \"$package\"" &>/dev/null; then
        echo "✅ Success"
        ((success_count++))
    else
        echo "❌ Failed" >&2
        failed_packages+=("$package")
    fi
done

echo ""
echo "=========================================="
echo "📦 Package Installation Summary:"
echo "  Total packages checked: $total_count"
echo "  Successful installations/checks: $success_count"
if [[ ${#failed_packages[@]} -gt 0 ]]; then
    echo "  Failed to install: ${#failed_packages[@]}"
    echo ""
    echo "⚠️ The following packages failed and require manual installation:"
    for pkg in "${failed_packages[@]}"; do
        echo "  - $pkg"
    done
else
    echo "✅ All required packages were successfully installed or found."
fi
echo "=========================================="
