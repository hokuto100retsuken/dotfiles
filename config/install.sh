#!/bin/bash

# if [ -d ~/.config/wezterm ]; then
#   mv ~/.config/wezterm ~/.config/wezterm.bak
# fi
ln -sfv $PWD/wezterm/ ~/.config/wezterm

# if [ -d ~/config/nvim ]; then
#    mv ~/.config/nvim ~/.config/nvim.bak
# fi
ln -sfv $PWD/nvim ~/.config/nvim

ln -sfv $PWD/fish ~/.config/fish
