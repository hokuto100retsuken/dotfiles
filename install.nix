{ pkgs ? import <nixpkgs> {} }:
[
  pkgs.zsh
  pkgs.bat
  pkgs.exa
  pkgs.docker
  pkgs.docker-compose
  pkgs.lazygit
  pkgs.neovim
  pkgs.sheldon
  pkgs.peco
  pkgs.ghq
  pkgs.starship
]
