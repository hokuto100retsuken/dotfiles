#!/bin/bash

DOTPATH=$(pwd)

ln -sfv $PWD/zsh/_zshrc ~/.zshrc

## sheldon
# ~/.config/sheldon/ のフォルダがないなら作成
[ -d ~/.config/sheldon ] || mkdir -p ~/.config/sheldon
ln -sfv $PWD/config/sheldon/plugins.toml ~/.config/sheldon/plugins.toml

# tmux config
ln -sfv $PWD/tmux/_tmux.conf ~/.tmux.conf

# git config
cp $PWD/git/_gitconfig ~/.gitconfig

# fish
[ -d ~/.config/fish ] || mkdir -p ~/.config/fish
ln -sfv $PWD/config/fish ~/.config/fish