# HomeBrewのインストール
if [ ! -x "`which brew`" ]; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  brew update
fi

brew install visual-studio-code  --cask
brew install docker              --cask

brew install git
brew install ghq
brew install peco
brew install asdf
# brew install starship
