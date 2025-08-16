#!/bin/bash

DOTPATH=$(pwd)

# starship
ln -sfv $PWD/config/starship.toml ~/.config/starship.toml

# git config
ln -sfv $PWD/git/_gitconfig ~/.gitconfig

# fish
[ -d ~/.config/fish ] || mkdir -p ~/.config/fish
ln -sfv $PWD/config/fish/config.fish ~/.config/fish/config.fish
ln -sfv $PWD/config/fish/conf.d ~/.config/fish/conf.d
ln -sfv $PWD/config/fish/functions ~/.config/fish/functions

# ghostty
[ -d ~/.config/ghostty ] || mkdir -p ~/.config/ghostty
ln -sfv $PWD/config/ghostty/config ~/.config/ghostty/config

# mise
[ -d ~/.config/mise ] || mkdir -p ~/.config/mise
ln -sfv $PWD/config/mise/config.toml ~/.config/mise/config.toml

# nvim
[ -d ~/.config/nvim ] || mkdir -p ~/.config/nvim
ln -sfv $PWD/config/nvim/init.lua ~/.config/nvim/init.lua
ln -sfv $PWD/config/nvim/lua ~/.config/nvim/lua
ln -sfv $PWD/config/nvim/sonictemplate ~/.config/nvim/sonictemplate

# zellij
[ -d ~/.config/zellij ] || mkdir -p ~/.config/zellij
ln -sfv $PWD/config/zellij/config.kdl ~/.config/zellij/config.kdl