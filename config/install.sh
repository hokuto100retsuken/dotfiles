#!/bin/bash

## sheldon
# ~/.config/sheldon/ のフォルダがないなら作成
[ -d ~/.config/sheldon ] || mkdir -p ~/.config/sheldon
ln -sfv $PWD/_config/sheldon/plugins.toml ~/.config/sheldon/plugins.toml
ln -sfv $PWD/_config/wezterm/ ~/.config/wezterm

if [[ ! -e ~/.config/starship.toml ]]; then
  ln -sfv $PWD/starship.toml ~/.config/starship.toml
fi
