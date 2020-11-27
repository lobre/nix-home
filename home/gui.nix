{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    discord
    filezilla
    gnome3.dconf-editor
    gnome3.meld
    google-chrome
    peek
    remmina
    slack
    spotify
    teams
  ];

  imports = [
    ./gui/pantheon.nix
    ./gui/copyq.nix
  ];
}
