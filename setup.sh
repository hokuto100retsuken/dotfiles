#!/bin/bash

echo 'setup'

DOTPATH=$(pwd)
CONFIG_PATH=~/.config/nvim

echo $DOTPATH

if [ ! -d "$CONFIG_PATH" ]; then
  mkdir -p ~/.config/nvim
fi

ln -sfv $DOTPATH/dotfiles/_zshrc ~/.zshrc
ln -sfv $DOTPATH/dotfiles/_config/starship.toml ~/.config/starship.toml

# nvim setting 
ln -sfv $DOTPATH/dotfiles/_config/nvim/init.lua ~/.config/nvim/init.lua
ln -sfv $DOTPATH/dotfiles/_config/nvim/lua ~/.config/nvim/

# tmux config
ln -sfv $DOTPATH/dotfiles/_tmux.conf ~/.tmux.conf

linux
if  [ "$(uname)" == "Linux" ]; then

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

  curl https://rtx.pub/install.sh | sh
  
  rtx plugin add ghq
  rtx install ghq

  # inatall docker

  # HomeBrewのインストール
  if [ ! -x "`which brew`" ]; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    brew update
  fi
fi

# Mac
if  [ "$(uname)" == "Darwin" ]; then

  sudo softwareupdate --install-rosetta

  # HomeBrewのインストール
  if [ ! -x "`which brew`" ]; then
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    brew update
  fi

  brew install visual-studio-code  --cask
  brew install docker              --cask
  brew install iterm2              --cask
  brew install sequel-pro          --cask

  brew install git
  brew install wget
  brew install asdf
  brew install peco
  brew install z
  brew install ghq
  brew install docker-compose
  brew install gh 

fi

# 共通
brew install starship

git config --global core.editor "nvim"

