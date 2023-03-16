#!bin/bash

DOTPATH=$~/src/github.com/hokuto100retsuken/dotfiles

CONFIG_PATH="~/.config/nvim"

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

