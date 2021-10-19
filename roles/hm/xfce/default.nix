{ pkgs, ... }:

{
  xdg.enable = true;

  home.packages = with pkgs; [
    brave
    filezilla
    gnome3.meld
    libnotify
    libreoffice
    pavucontrol
    peek
    pinta
    remmina
    slack
    spotify
    teams
    vlc
    xclip
  ];

  imports = [
    ./oni.nix
    ./panel.nix
    ./terminal.nix
    ./xfconf.nix
  ];
}

