{ pkgs, ... }:

{
  xdg.enable = true;

  home.packages = with pkgs; [
    brave
    discord
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
    wine
  ];

  imports = [
    ./oni.nix
    ./panel.nix
    ./terminal.nix
    ./vscode.nix
    ./xfconf.nix
  ];
}

