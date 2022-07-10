#!bin/bash

### linux brew install
touch ~/.zprofile

/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

test -d ~/.linuxbrew && eval $(~/.linuxbrew/bin/brew shellenv)
test -d /home/linuxbrew/.linuxbrew && eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)
test -r ~/.zprofile && echo "eval \$($(brew --prefix)/bin/brew shellenv)" >>~/.zprofile
echo "eval \$($(brew --prefix)/bin/brew shellenv)" >>~/.profile
