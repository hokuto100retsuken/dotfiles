#!/bin/bash

if [[ ! -e $HOME/.tmux.conf ]]; then
  ln -s $PWD/tmux/_tmux.conf ~/.tmux.conf
fi
