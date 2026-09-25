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
    # Linux (Arch 系。CachyOS は paru が標準で入っているので paru を優先する)
    if command -v paru &> /dev/null; then
        PACKAGE_MANAGER="paru"
    elif command -v yay &> /dev/null; then
        PACKAGE_MANAGER="yay"
    else
        echo "Error: AUR helper (paru or yay) not found. Install one first." >&2
        exit 1
    fi
    is_installed() { pacman -Qq "$1" &> /dev/null; }
    install_package() { "$PACKAGE_MANAGER" -S --needed --noconfirm "$1"; }
    packages=(
        "fish"
        "github-cli"
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
        "herdr-bin"
        "lazygit"
        "git-delta"
        "difftastic"
        "nkf"
        "gcc"
        "tree-sitter-cli"
        "wl-clipboard"
        "ghostty"
        "ttf-udev-gothic"
        "ttf-hackgen"
        "ttf-jetbrains-mono-nerd"
        "ast-grep"
        "glow"
        "hyperfine"
        "watchexec"
        "tree"
        "wget"
        "git-filter-repo"
        "ctop"
        "act"
        "lazydocker"
        "tealdeer"
        "poppler"
        "vim"
        "mkcert"
        "ollama"
        "docker"
        "docker-compose"
        "docker-buildx"
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
    # "cask:" 付きは GUI アプリ・フォント
    is_installed() {
        case "$1" in
            cask:*) brew list --cask "${1#cask:}" &> /dev/null ;;
            *) brew list --formula "$1" &> /dev/null ;;
        esac
    }
    install_package() {
        case "$1" in
            cask:*) brew install --cask "${1#cask:}" ;;
            *) brew install "$1" ;;
        esac
    }
    packages=(
        "bash"
        "fish"
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
        "zoxide"
        "zellij"
        "herdr"
        "lazygit"
        "git-delta"
        "difftastic"
        "nkf"
        "gcc"
        "tree-sitter-cli"
        "cask:ghostty"
        "cask:font-udev-gothic-nf"
        "ast-grep"
        "glow"
        "hyperfine"
        "watchexec"
        "tree"
        "wget"
        "git-filter-repo"
        "ctop"
        "act"
        "lazydocker"
        "tealdeer"
        "poppler"
        "vim"
        "mkcert"
        "ollama"
        "docker"
        "docker-compose"
        "docker-buildx"
        "colima"
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
    if is_installed "$package"; then
        echo "✅ Already installed: $package"
        ((success_count++))
        continue
    fi

    echo "📦 Installing $package..."
    if install_package "$package"; then
        echo "✅ Success: $package"
        ((success_count++))
    else
        echo "❌ Failed: $package" >&2
        failed_packages+=("$package")
    fi
done

# Linux の docker はデーモンの起動と、sudo なしで使うための docker グループ参加が要る
if [[ "$OSTYPE" == "linux-gnu"* ]] && is_installed docker; then
    echo ""
    echo "🐳 Enabling docker service..."
    sudo systemctl enable --now docker.service
    if ! id -nG "$USER" | grep -qw docker; then
        sudo usermod -aG docker "$USER"
        echo "⚠️ Added $USER to docker group. Log out and back in to use docker without sudo."
    fi
fi

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

# 1件でも失敗したら setup.sh 側で失敗として扱わせる
[[ ${#failed_packages[@]} -eq 0 ]]
