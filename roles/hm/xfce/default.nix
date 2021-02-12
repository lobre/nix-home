{ pkgs, ... }:

{
  xdg.enable = true;

  home.packages = with pkgs; [
    brave
    filezilla
    gnome3.meld
    libnotify
    pavucontrol
    peek
    pinta
    remmina
    slack
    spotify
    teams
    vlc
    xclip

    arc-theme
    papirus-icon-theme
  ];

  imports = [
    ./xfconf.nix
    ./terminal.nix
    ./panel.nix
  ];
}

