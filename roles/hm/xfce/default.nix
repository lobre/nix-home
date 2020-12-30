{ pkgs, ... }:

{
  xdg.enable = true;

  home.packages = with pkgs; [
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
    ./xfconf.nix
    ./terminal.nix
    ./panel.nix
  ];
}

