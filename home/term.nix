{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    curl
    docker
    docker_compose
    git
    htop 
    ranger
    ripgrep
    tree
    unzip
    vim_configurable 
    wget 
  ];

  # Link scripts
  home.file."bin-term" = {
    source = ./term/bin;
    target = "bin";
    recursive = true;
  };

  imports = [
    ./term/bash.nix
    ./term/zsh.nix
    ./term/go.nix
    ./term/tmux.nix
  ];
}
