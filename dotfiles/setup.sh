#!bin/bash

ln -sfv `pwd`/_zshrc ~/.zshrc
ln -sfv `pwd`/_config/starship.toml ~/.config/starship.toml

# nvim setting 
ln -sfv `pwd`/_config/nvim/init.lua ~/.config/nvim/init.lua
ln -sfv `pwd`/_config/nvim/lua ~/.config/nvim/

# tmux config
ln -sfv `pwd`/_tmux.conf ~/.tmux.conf

