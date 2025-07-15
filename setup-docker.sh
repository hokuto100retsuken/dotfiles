#!/bin/bash

set -e

# Detect OS
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    # Linux
    if command -v pacman &> /dev/null; then
        # Arch Linux
        echo "Installing Docker on Arch Linux..."
        yay -S docker
        sudo usermod -aG docker $USER
        newgrp docker
        sudo systemctl enable docker
        sudo systemctl start docker
    else
        echo "Unsupported Linux distribution. Please install Docker manually."
        exit 1
    fi
elif [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS
    if command -v brew &> /dev/null; then
        echo "Installing Docker on macOS..."
        brew install --cask docker
        echo "Docker Desktop has been installed. Please start Docker Desktop manually."
    else
        echo "Homebrew is not installed. Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        
        # Add Homebrew to PATH for Apple Silicon Macs
        if [[ $(uname -m) == "arm64" ]]; then
            echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
            eval "$(/opt/homebrew/bin/brew shellenv)"
        fi
        
        echo "Installing Docker on macOS..."
        brew install --cask docker
        echo "Docker Desktop has been installed. Please start Docker Desktop manually."
    fi
else
    echo "Unsupported operating system: $OSTYPE"
    exit 1
fi

echo "Docker installation completed."