#!/bin/bash

## sheldon
# ~/.config/sheldon/ のフォルダがないなら作成
[ -d ~/.config/sheldon ] || mkdir -p ~/.config/sheldon
ln -sfv $PWD/sheldon/plugins.toml ~/.config/sheldon/plugins.toml


if [ -d ~/.config/wezterm ]; then
  mv ~/.config/wezterm ~/.config/wezterm.bak
fi
ln -sfv $PWD/wezterm/ ~/.config/wezterm

if [ -d ~/config/nvim ]; then
   mv ~/.config/nvim ~/.config/nvim.bak
fi
ln -sfv $PWD/nvim ~/.config/nvim

if [ ! -e ~/.config/starship.toml ]; then
  ln -sfv $PWD/starship.toml ~/.config/starship.toml
fi