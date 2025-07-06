#!/bin/bash

# This script installs essential packages using yay.

# List of packages to install
packages=(
    "gh"
    "fzf"
    "ripgrep"
    "bat"
    "fd"
    "exa"
    "jq"
    "go-yq"
    "starship"
)

# Install packages with yay
yay -S --needed "${packages[@]}"

echo "All specified packages are installed."
