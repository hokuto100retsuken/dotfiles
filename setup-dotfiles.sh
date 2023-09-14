#!/bin/bash

DOTPATH=$(pwd)

ln -sfv $DOTPATH/dotfiles/_zshrc ~/.zshrc
# ~/.config/sheldon/ のフォルダがないなら作成
[ -d ~/.config/sheldon ] || mkdir -p ~/.config/sheldon
ln -sfv $DOTPATH/dotfiles/_config/sheldon/plugins.toml ~/.config/sheldon/plugins.toml
ln -sfv $DOTPATH/dotfiles/_config/starship.toml ~/.config/starship.toml

# tmux config
ln -sfv $DOTPATH/dotfiles/_tmux.conf ~/.tmux.conf
