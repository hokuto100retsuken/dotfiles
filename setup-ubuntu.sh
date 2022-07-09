#!/bin/bash

sudo apt-get install -y git

git clone https://github.com/asdf-vm/asdf ~/.asdf
# sudo chmod +x ~/.asdf/asdf.sh
exec $SHELL -l

sudo apt install peco

# HomeBrewのインストール
if [ ! -x "`which brew`" ]; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  brew update
fi

# brew install visual-studio-code  --cask
# brew install docker              --cask

# brew install ghq
# brew install peco
# brew install asdf
# brew install starship

