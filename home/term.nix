{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    curl
    ctags
    docker
    docker_compose
    dos2unix
    htop 
    httpie
    jq
    ltrace
    ncdu
    pv
    ranger
    ripgrep
    tcpdump
    traceroute
    tree
    unzip
    wget 
  ];

  # Link scripts
  home.file."bin-term" = {
    source = ./term/bin;
    target = "bin";
    recursive = true;
  };

  # Set ranger configuration
  xdg.configFile."ranger/rc.conf".source = ./term/ranger/rc.conf;

  # Set lesskey config
  home.file.".lesskey".source = ./term/less/lesskey;

  imports = [
    ./term/bash.nix
    ./term/zsh.nix
    ./term/go.nix
    ./term/tmux.nix
    ./term/vim.nix
    ./term/git.nix
    ./term/fzf.nix
  ];
}
