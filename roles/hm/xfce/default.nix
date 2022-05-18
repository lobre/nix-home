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
    qtpass
    remmina
    slack
    spotify
    teams
    vlc
    xclip
    xdotool
    wine
  ];

  programs.browserpass.enable = true;

  imports = [
    ./panel.nix
    ./terminal.nix
    ./xfconf.nix
  ];
}
