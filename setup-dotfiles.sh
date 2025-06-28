#!/bin/bash

DOTPATH=$(pwd)

## sheldon
# ~/.config/sheldon/ のフォルダがないなら作成
[ -d ~/.config/sheldon ] || mkdir -p ~/.config/sheldon
ln -sfv $PWD/config/sheldon/plugins.toml ~/.config/sheldon/plugins.toml

# tmux config
ln -sfv $PWD/tmux/_tmux.conf ~/.tmux.conf

# git config
cp $PWD/git/_gitconfig ~/.gitconfig

# fish
[ -d ~/.config/fish/functions ] || mkdir -p ~/.config/fish/functions
ln -sfv $PWD/config/fish/config.fish ~/.config/fish/config.fish
ln -sfv $PWD/config/fish/functions ~/.config/fish/functions

# mise
[ -d ~/.config/mise ] || mkdir -p ~/.config/mise
ln -sfv $PWD/config/mise/config.toml ~/.config/mise/config.toml

# aqua
[ -d ~/.config/aqua ] || mkdir -p ~/.config/aqua
ln -sfv $PWD/config/aqua/aqua.yaml ~/.config/aqua/aqua.yaml