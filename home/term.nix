{ config, pkgs, ... }:

let
  nixSwitch = pkgs.writeScriptBin "nix-switch" ''
    #!${pkgs.stdenv.shell}
    user="$USER"
    if [[ -n "$SUDO_USER" ]]; then
        user="$SUDO_USER"
    fi
    exec "/home/$user/Lab/nix-home/nix-switch.sh" "$@"
  '';
in

{
  programs.bash.profileExtra = ''
      # Add bin in PATH if not already existing
      [[ ":$PATH:" != *":$HOME/bin:"* ]] && export PATH="$PATH:$HOME/bin"
  '';

  home.packages = with pkgs; [
    # custom script to easily switch configuration
    nixSwitch

    binutils-unwrapped
    ctags
    curl
    docker
    docker_compose
    dos2unix
    fd
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
    sqlite
    strace
    tcpdump
    traceroute
    tree
    unzip
    wget 
    yarn
  ];

  # Allow XDG linking
  xdg.enable = true;

  imports = [
    ./term/shell.nix
    ./term/tmux.nix
    ./term/go.nix
    ./term/vim.nix
    ./term/git.nix
  ];
}
