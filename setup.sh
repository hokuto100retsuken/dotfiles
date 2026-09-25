#!/bin/bash

set -euo pipefail

SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

# --- Color Definitions & Logging ---
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Logging functions
info() { echo -e "${BLUE}[INFO]${NC} $1"; }
success() { echo -e "${GREEN}[✓]${NC} $1"; }
warn() { echo -e "${YELLOW}[⚠]${NC} $1"; }
error() { echo -e "${RED}[✗]${NC} $1" >&2; }

# --- Setup Functions (Wrappers) ---

run_install() {
    info "Starting package installation..."
    if bash "$SCRIPT_DIR/scripts/setup-installs.sh"; then
        success "Package installation process finished."
        return 0
    else
        warn "Package installation encountered errors. Please check the output above."
        return 1
    fi
}

run_dotfiles() {
    info "Creating dotfile symbolic links..."
    if bash "$SCRIPT_DIR/scripts/setup-dotfiles.sh"; then
        success "Dotfiles linking completed successfully."
        return 0
    else
        error "Dotfiles setup failed. Check permissions or source paths."
        return 1
    fi
}

run_mise() {
    info "Installing tools managed by mise (neovim, node, go, claude, ...)..."
    if mise install; then
        success "mise install completed successfully."
        return 0
    else
        error "mise install failed."
        return 1
    fi
}

run_fish() {
    info "Setting up Fish Shell plugins..."
    if bash "$SCRIPT_DIR/scripts/setup-fish.sh"; then
        success "Fish shell setup completed successfully."
        return 0
    else
        error "Fish shell setup failed."
        return 1
    fi
}

# --- User Interface Functions ---

show_help() {
    cat << EOF
========================================
Dotfiles Setup Script (setup.sh)
========================================
This script manages the installation of development tools and configuration files.

Usage:
    ./setup.sh [OPTIONS]

Options:
    -a, --all       Run all setup steps (Install -> Dotfiles -> Mise -> Fish).
    -i, --install   Run package installation only.
    -d, --dotfiles  Create dotfile symlinks only.
    -m, --mise      Install tools managed by mise only.
    -f, --fish      Setup fish shell plugins only.
    --interactive   Interactive mode: Prompts user for desired setup steps.
    -h, --help      Show this help message.

Examples:
    ./setup.sh              # Interactive mode (default)
    ./setup.sh --all        # Run everything
    ./setup.sh -i -d        # Install packages and link dotfiles only

========================================
EOF
}

confirm() {
    local message="$1"
    local default="${2:-N}"
    local prompt_text

    if [[ "$default" == "Y" ]]; then
        prompt_text="[Y/n]"
    else
        prompt_text="[y/N]"
    fi

    echo -ne "${YELLOW}❓ $message $prompt_text ${NC}"
    read -r response
    response=${response:-$default}

    [[ "$response" =~ ^[Yy]$ ]]
}

# --- Main Execution Logic ---

run_all() {
    echo ""
    info "=========================================="
    info "Starting Full Dotfiles Setup Process"
    info "OS: $(uname -s) ($(uname -m))"
    info "=========================================="
    echo ""

    local has_error=false

    # 1. Install Packages
    if ! run_install; then
        if ! confirm "Installation failed. Continue with dotfiles anyway?"; then
            error "Setup aborted by user."
            exit 1
        fi
        has_error=true
    fi
    echo ""

    # 2. Setup Dotfiles
    if ! run_dotfiles; then
        has_error=true
    fi
    echo ""

    # 3. Install mise tools (config.toml is linked in step 2)
    if command -v mise &> /dev/null; then
        if ! run_mise; then
            has_error=true
        fi
        echo ""
    else
        warn "mise not found. Skipping mise install."
    fi

    # 4. Setup Fish Shell (Only if fish is available)
    if command -v fish &> /dev/null; then
        if ! run_fish; then
            has_error=true
        fi
        echo ""
    else
        warn "Fish shell not found. Skipping fish setup."
    fi

    echo "=========================================="
    if [[ "$has_error" == true ]]; then
        warn "Setup finished, but one or more steps encountered errors. Please review the logs above."
    else
        success "🎉 Setup completed successfully! Remember to restart your terminal session."
    fi
    echo "=========================================="
    [[ "$has_error" == false ]]
}

run_interactive() {
    echo ""
    info "========================================="
    info "Dotfiles Setup (Interactive Mode)"
    info "OS: $(uname -s) ($(uname -m))"
    info "========================================="
    echo ""

    local run_install_flag=false
    local run_dotfiles_flag=false
    local run_mise_flag=false
    local run_fish_flag=false

    if confirm "1. Install system packages (Recommended)" "Y"; then
        run_install_flag=true
    fi

    if confirm "2. Create dotfile symlinks" "Y"; then
        run_dotfiles_flag=true
    fi

    if confirm "3. Install tools managed by mise" "Y"; then
        run_mise_flag=true
    fi

    if command -v fish &> /dev/null; then
        if confirm "4. Setup Fish Shell plugins (Requires 'fish' installed)" "N"; then
            run_fish_flag=true
        fi
    else
        warn "Fish shell not found. Skipping option 4."
    fi

    echo ""

    local has_error=false

    if [[ "$run_install_flag" == true ]]; then
        run_install || has_error=true
        echo ""
    fi

    if [[ "$run_dotfiles_flag" == true ]]; then
        run_dotfiles || has_error=true
        echo ""
    fi

    if [[ "$run_mise_flag" == true ]]; then
        run_mise || has_error=true
        echo ""
    fi

    if [[ "$run_fish_flag" == true ]]; then
        run_fish || has_error=true
        echo ""
    fi

    echo "=========================================="
    if [[ "$has_error" == true ]]; then
        warn "Setup finished, but one or more steps encountered errors."
    else
        success "🎉 Setup completed successfully! Remember to restart your terminal session."
    fi
    echo "=========================================="
    [[ "$has_error" == false ]]
}

# --- Argument Parsing and Main Entry Point ---

main() {
    local do_install=false
    local do_dotfiles=false
    local do_mise=false
    local do_fish=false
    local do_all=false
    local do_interactive=false

    while [[ $# -gt 0 ]]; do
        case "$1" in
            -h|--help)
                show_help
                exit 0
                ;;
            -a|--all)
                do_all=true
                shift
                ;;
            -i|--install)
                do_install=true
                shift
                ;;
            -d|--dotfiles)
                do_dotfiles=true
                shift
                ;;
            -m|--mise)
                do_mise=true
                shift
                ;;
            -f|--fish)
                do_fish=true
                shift
                ;;
            --interactive)
                do_interactive=true
                shift
                ;;
            *)
                error "Unknown option: $1"
                show_help
                exit 1
                ;;
        esac
    done

    if [[ "$do_interactive" == true ]]; then
        run_interactive
        return 0
    fi

    if [[ "$do_all" == true ]]; then
        run_all
        return 0
    fi

    local has_error=false
    local ran_something=false

    # Execute steps based on flags
    if [[ "$do_install" == true ]]; then
        run_install || has_error=true
        ran_something=true
        echo ""
    fi

    if [[ "$do_dotfiles" == true ]]; then
        run_dotfiles || has_error=true
        ran_something=true
        echo ""
    fi

    if [[ "$do_mise" == true ]]; then
        run_mise || has_error=true
        ran_something=true
        echo ""
    fi

    if [[ "$do_fish" == true ]]; then
        # Only run fish setup if the 'fish' command exists
        if command -v fish &> /dev/null; then
            run_fish || has_error=true
            ran_something=true
            echo ""
        else
            warn "Fish shell not found. Skipping fish setup."
        fi
    fi

    if [[ "$ran_something" == false ]]; then
        error "No valid tasks specified. Use -h or --help for options."
        exit 1
    fi

    if [[ "$has_error" == true ]]; then
        exit 1
    else
        success "All requested setup steps completed successfully!"
    fi
}

main "$@"
