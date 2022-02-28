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

  home.username = secrets.username;
  home.homeDirectory = secrets.homeDirectory;

  home.packages = with pkgs; [
    # custom script to easily switch configuration
    nixSwitch

    curl
    docker
    docker-compose
    dos2unix
    entr
    fd
    file
    gcc
    gettext # for envsubst
    git-credential-gopass
    gopass
    gopass-jsonapi
    graph-easy
    htop 
    httpie
    jq
    killall
    ltrace
    ncdu
    openssh
    pandoc
    perl
    pv
    ripgrep
    rmapi
    slides
    strace
    tcpdump
    texlive.combined.scheme-small
    traceroute
    tree
    universal-ctags
    unrar
    unzip
    wget 
    yarn
    yq-go
  ];

  xdg.enable = true;

  services.dropbox.enable = true;

  imports = [
    ./git.nix
    ./gpg.nix
    ./lang.nix
    ./shell.nix
    ./tmux.nix
    ./vim.nix
  ];
}
