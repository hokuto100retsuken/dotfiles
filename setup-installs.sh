#!/bin/bash

# Function to install common packages
install_common_packages() {

  git config --global core.editor "nvim"
  git config --global ghq.root '~/src'
}

# Install packages for Ubuntu
install_ubuntu() {
  install_common_packages
 
  sudo apt-get -y update
  sudo apt-get -y upgrade

  sudo apt-get install -y git \
        build-essential \
        procps \
        curl \
        file \
        ripgrep \
        nvim

  sudo apt install -y gnome-tweaks \
        peco \
        bat \
        tig

    # curl https://rtx.pub/install.sh | sh

  # Install docker
  sudo apt-get install -y docker.io
}

# Install packages for EndeavourOS
install_endeavouros() {
  install_common_packages

  yay -Syyu
  # yay -S docker

  # Install docker
}

# Install packages for macOS
install_mac() {
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  brew update

  brew install visual-studio-code --cask
  brew install docker --cask
  brew install iterm2 --cask
  brew install sequel-pro --cask

  install_common_packages

  # Install docker
  brew install docker-compose
}

# Determine the OS and call the appropriate function
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
  if [ -f "/etc/arch-release" ]; then
    install_endeavouros
  else
    # install_ubuntu
        echo 'ubuntu'
  fi
elif [[ "$OSTYPE" == "darwin"* ]]; then
  # install_mac
  echo 'mac'
else
  echo "Unsupported OS"
  exit 1
fi
