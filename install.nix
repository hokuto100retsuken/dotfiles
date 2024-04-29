{ pkgs ? import <nixpkgs> {} }:
[
  pkgs.asdf
  pkgs.bat
  pkgs.docker
  pkgs.docker-compose
  pkgs.ghq
  pkgs.exa
  pkgs.lazygit
  pkgs.neovim
  pkgs.peco
  pkgs.sheldon
  pkgs.starship
  pkgs.zsh
]
