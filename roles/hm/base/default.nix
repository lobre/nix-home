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
  nixpkgs.config = { allowUnfree = true; };

  programs.home-manager.enable = true;
  programs.direnv.enable = true;

  services.dropbox.enable = true;

  xdg.enable = true;

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
    dos2unix
    entr
    file
    gcc
    gettext # for envsubst
    glow
    jq
    killall
    ltrace
    ncdu
    openssh
    pandoc
    pass
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
    yq-go
  ];

  imports = [
    ./git.nix
    ./gpg.nix
    ./kakoune.nix
    ./lang.nix
    ./shell.nix
    ./tmux.nix
    ./vim.nix
  ];
}
