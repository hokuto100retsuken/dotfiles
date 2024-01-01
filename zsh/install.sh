#!/bin/bash

if [[ ! -e $HOME/.zshrc ]]; then
  ln -s $PWD/_zshrc $HOME/.zshrc
fi
