#!bin/bash

DOTPATH=$(ghq root)/github.com/hokuto100retsuken/dotfiles

ln -sfv $DOTPATH/dotfiles/_zshrc ~/.zshrc
ln -sfv $DOTPATH/dotfiles/_config/starship.toml ~/.config/starship.toml

# nvim setting 
ln -sfv $DOTPATH/dotfiles/_config/nvim/init.lua ~/.config/nvim/init.lua
ln -sfv $DOTPATH/dotfiles/_config/nvim/lua ~/.config/nvim/

# tmux config
ln -sfv $DOTPATH/dotfiles/_tmux.conf ~/.tmux.conf

