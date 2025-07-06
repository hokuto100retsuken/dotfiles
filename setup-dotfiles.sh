#!/bin/bash

DOTPATH=$(pwd)

## sheldon
# ~/.config/sheldon/ のフォルダがないなら作成
[ -d ~/.config/sheldon ] || mkdir -p ~/.config/sheldon
ln -sfv $PWD/config/sheldon/plugins.toml ~/.config/sheldon/plugins.toml

# tmux config
ln -sfv $PWD/tmux/_tmux.conf ~/.tmux.conf

# git config
ln -sfv $PWD/git/_gitconfig ~/.gitconfig

# fish
[ -d ~/.config/fish ] || mkdir -p ~/.config/fish
ln -sfv $PWD/config/fish/config.fish ~/.config/fish/config.fish
ln -sfv $PWD/config/fish/conf.d ~/.config/fish/conf.d
ln -sfv $PWD/config/fish/functions ~/.config/fish/functions

