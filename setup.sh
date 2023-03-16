#!/bin/bash

# linux
if  [ "$(uname)" == "Linux" ]; then

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
  echo -e "\neval \"\$(/home/hkt100rtkn/.local/share/rtx/bin/rtx activate -s zsh)\"" >> ~/.zshrc

  rtx plugin add ghq
  rtx install ghq

  # inatall docker

  # HomeBrewのインストール
  # if [ ! -x "`which brew`" ]; then
  #   /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  #   brew update
  # fi
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
git config --global core.editor "nvim"

