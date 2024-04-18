#!/bin/bash

## sheldon
# ~/.config/sheldon/ のフォルダがないなら作成
[ -d ~/.config/sheldon ] || mkdir -p ~/.config/sheldon
ln -sfv $PWD/sheldon/plugins.toml ~/.config/sheldon/plugins.toml

[ -d ~/.config/wezterm ] || mv ~/.config/wezterm ~/.config/wezterm.bak
ln -sfv $PWD/wezterm/ ~/.config/wezterm

[ -d ~/config/nvim ] || mv ~/.config/nvim ~/.config/nvim.bak
ln -sfv $PWD/nvim ~/.config/nvim

if [ ! -e ~/.config/starship.toml ]; then
  ln -sfv $PWD/starship.toml ~/.config/starship.toml
fi