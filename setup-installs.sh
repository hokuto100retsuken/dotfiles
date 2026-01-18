#!/bin/bash

set -uo pipefail

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
            "zoxide"
            "zellij"
            "ghostty"
            "nerd-fonts-hack-gen"
            "nerd-fonts-jetbrains-mono"
            "docker"
            "docker-compose"
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
echo ""

# Install packages one by one to handle errors better
failed_packages=()
success_count=0
total_count=${#packages[@]}

for package in "${packages[@]}"; do
    echo -n "Installing $package... "
    if $INSTALL_CMD "$package" &>/dev/null; then
        echo "✓"
        ((success_count++))
    else
        echo "✗"
        failed_packages+=("$package")
    fi
done

echo ""
echo "=========================================="
echo "パッケージインストール結果:"
echo "  成功: $success_count / $total_count"
if [[ ${#failed_packages[@]} -gt 0 ]]; then
    echo "  失敗: ${#failed_packages[@]}"
    echo ""
    echo "失敗したパッケージ:"
    for pkg in "${failed_packages[@]}"; do
        echo "  - $pkg"
    done
    echo ""
    echo "これらのパッケージは手動でインストールしてください"
else
    echo "  すべてのパッケージが正常にインストールされました"
fi
echo "=========================================="
