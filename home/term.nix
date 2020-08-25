{ config, pkgs, ... }:

{
  programs.bash.profileExtra = ''
      # Add bin in PATH if not already existing
      [[ ":$PATH:" != *":$HOME/bin:"* ]] && export PATH="$PATH:$HOME/bin"
  '';

  home.packages = with pkgs; [
    binutils-unwrapped
    curl
    ctags
    docker
    docker_compose
    dos2unix
    file
    htop 
    httpie
    jq
    killall
    ltrace
    ncdu
    nodejs
    perl
    pv
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

  # Allow XDG linking
  xdg.enable = true;

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
