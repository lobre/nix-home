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
    ./xfconf.nix
    ./terminal.nix
    ./panel.nix
  ];
}

