{ pkgs, ... }:

{
  xdg.enable = true;

  home.packages = with pkgs; [
    brave
    discord
    filezilla
    meld
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
    xdotool
    wine
  ];

  imports = [
    ./panel.nix
    ./terminal.nix
    ./xfconf.nix
  ];
}
