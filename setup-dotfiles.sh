#!/bin/bash

DOTPATH=$(pwd)

ln -sfv $PWD/zsh/_zshrc ~/.zshrc

## sheldon
# ~/.config/sheldon/ のフォルダがないなら作成
[ -d ~/.config/sheldon ] || mkdir -p ~/.config/sheldon
ln -sfv $PWD/config/_config/sheldon/plugins.toml ~/.config/sheldon/plugins.toml

## nvim
# ~/.config/astronvim/lua/user/plugins のフォルダがないなら作成
[ -d ~/.config/astronvim/lua/user/plugins ] || mkdir -p ~/.config/astronvim/lua/user/plugins
ln -sfv $PWD/config/_config/astronvim/lua/user/plugins/user.lua ~/.config/astronvim/lua/user/plugins/user.lua
# ln -sfv $PWD/dotfiles/_config/starship.toml ~/.config/starship.toml

# tmux config
ln -sfv $PWD/tmux/_tmux.conf ~/.tmux.conf

# git config
cp $PWD/git/_gitconfig ~/.gitconfig
