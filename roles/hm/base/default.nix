{ config, pkgs, secrets, ... }:

let
  nixSwitch = pkgs.writeScriptBin "nix-switch" ''
    #!${pkgs.stdenv.shell}
    user="$USER"
    if [[ -n "$SUDO_USER" ]]; then
        user="$SUDO_USER"
    fi
    exec "/home/$user/lab/github.com/lobre/nix-home/nix-switch.sh" "$@"
  '';
in

{
  programs.home-manager.enable = true;

  nixpkgs.config = { allowUnfree = true; };

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
    gopass
    htop 
    httpie
    jq
    killall
    ltrace
    ncdu
    nodejs
    openssh
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

  xdg.enable = true;

  imports = [
    ./shell.nix
    ./gpg.nix
    ./tmux.nix
    ./go.nix
    ./vim.nix
    ./git.nix
  ];
}
