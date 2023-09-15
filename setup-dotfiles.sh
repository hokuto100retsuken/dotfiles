#!/bin/bash

DOTPATH=$(pwd)

ln -sfv $DOTPATH/dotfiles/_zshrc ~/.zshrc

## sheldon
# ~/.config/sheldon/ のフォルダがないなら作成
[ -d ~/.config/sheldon ] || mkdir -p ~/.config/sheldon
ln -sfv $DOTPATH/dotfiles/_config/sheldon/plugins.toml ~/.config/sheldon/plugins.toml

## nvim
# ~/.config/astronvim/lua/user/plugins のフォルダがないなら作成
[ -d ~/.config/astronvim/lua/user/plugins ] || mkdir -p ~/.config/astronvim/lua/user/plugins
ln -sfv $DOTPATH/dotfiles/_config/astronvim/lua/user/plugins/user.lua ~/.config/astronvim/lua/user/plugins/user.lua
# ln -sfv $DOTPATH/dotfiles/_config/starship.toml ~/.config/starship.toml

# tmux config
ln -sfv $DOTPATH/dotfiles/_tmux.conf ~/.tmux.conf

# git config
cp $DOTPATH/dotfiles/_gitconfig ~/.gitconfig
