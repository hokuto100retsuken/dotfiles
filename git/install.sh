#!/bin/bash

if [[ ! -e $HOME/.gitconfig ]]; then
  cp $PWD/_gitconfig ~/.gitconfig
fi

