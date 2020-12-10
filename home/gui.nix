{ config, pkgs, ... }:

{
  xdg.enable = true;

  home.packages = with pkgs; [
    discord
    filezilla
    gnome3.meld
    google-chrome
    libnotify
    pavucontrol
    peek
    remmina
    slack
    spotify
    teams

    arc-theme
    papirus-icon-theme
  ];

  imports = [
    ./gui/xfconf.nix
    ./gui/terminal.nix
    ./gui/menu.nix
  ];
}
