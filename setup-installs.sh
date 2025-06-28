#!/bin/bash

# This script installs necessary packages based on the operating system.

# Function to install packages for Ubuntu
install_ubuntu() {
  echo "--- Installing packages for Ubuntu ---"
  sudo apt-get -y update
  sudo apt-get -y upgrade
  sudo apt-get install -y git build-essential procps curl file nvim gnome-tweaks peco
  
  echo "--- Installing mise ---"
  curl https://mise.run | sh

  echo "--- Installing aqua ---"
  curl -sL https://raw.githubusercontent.com/aquaproj/aqua-installer/v2.2.0/aqua-installer | bash

  echo "--- Installing Docker ---"
  sudo apt-get install -y docker.io
  echo "--------------------------------------"
}

# Function to install packages for Arch Linux
install_archlinux() {
  echo "--- Installing packages for Arch Linux ---"
  yay -Syyu
  yay -S --noconfirm ghq neovim mise aqua-bin

  echo "------------------------------------------"
}

# Function to install packages for macOS
install_mac() {
  echo "--- Installing packages for macOS ---"
  # Check for Homebrew and install if we don't have it
  if test ! $(which brew); then
    echo "Installing homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  fi

  brew update
  brew install ghq sheldon
  brew install --cask visual-studio-code docker iterm2 sequel-pro

  # Install mise & aqua
  brew install mise aqua
  echo "-----------------------------------"
}

# Determine the OS and call the appropriate function
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
  # Check for Arch Linux
  if [ -f "/etc/arch-release" ]; then
    install_archlinux
  # Assume Ubuntu otherwise
  else
    install_ubuntu
  fi
elif [[ "$OSTYPE" == "darwin"* ]]; then
  install_mac
else
  echo "Unsupported OS: $OSTYPE"
  exit 1
fi