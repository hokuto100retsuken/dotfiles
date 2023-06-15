#!/bin/bash

ln -sfv $DOTPATH/dotfiles/_zshrc ~/.zshrc
ln -sfv $DOTPATH/dotfiles/_config/starship.toml ~/.config/starship.toml

# tmux config
ln -sfv $DOTPATH/dotfiles/_tmux.conf ~/.tmux.conf
