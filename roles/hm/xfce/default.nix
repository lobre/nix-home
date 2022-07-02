{ pkgs, ... }:

{
  xdg.enable = true;

  home.packages = with pkgs; [
    discord
    filezilla
    firefox
    libnotify
    libreoffice
    meld
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
  ];

  programs.browserpass.enable = true;

  imports = [
    ./terminal.nix
    ./xfconf.nix
  ];
}
