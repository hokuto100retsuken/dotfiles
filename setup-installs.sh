!/bin/bash

# Function to install common packages
install_common_packages() {
  git clone --depth 1 https://github.com/AstroNvim/AstroNvim ~/.config/nvim
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

# Install packages for archlinux
install_archlinux() {
  install_common_packages
  yay paru
  yay -Syyu
  yay ghq
  yay fzf
  yay bat
  yay exa
  yay fd

  # sudo pacman -S starship
  
  # setup japanese
  sudo pacman -S noto-fonts-cjk

  sudo pacman -S fcitx5-mozc fcitx5-im
  # /etc/environment に以下を追記  
  sudo echo -e "\n# Fcitx5 env\nGTK_IM_MODULE=fcitx\nQT_IM_MODULE=fcitx\nXMODIFIERS=@im=fcitx" >> /etc/environment
}

# Install packages for macOS
install_mac() {
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  brew update
  brew install visual-studio-code --cask
  brew install docker --cask
  brew install iterm2 --cask
  brew install sequel-pro --cask
  brew install peco
  brew install ghq
  brew install asdf
  brew install exa
  brew install bat
  brew install sheldon
  install_common_packages
  brew install docker-compose
}

# Determine the OS and call the appropriate function
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
  if [ -f "/etc/arch-release" ]; then
    install_archlinux
  else
    install_ubuntu
  fi
elif [[ "$OSTYPE" == "darwin"* ]]; then
  # install_mac
  echo 'mac'
else
  echo "Unsupported OS"
  exit 1
fi
