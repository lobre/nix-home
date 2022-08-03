{ pkgs, ... }:

{
  xdg.enable = true;

  home.packages = with pkgs; [
    discord
    filezilla
    firefox
    iosevka
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
  fonts.fontconfig.enable = true;

  imports = [
    ./terminal.nix
    ./xfconf.nix
  ];
}
