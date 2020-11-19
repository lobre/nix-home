{ config, pkgs, ... }:

let
  wallpaper = pkgs.stdenv.mkDerivation {
    pname = "wallpaper";
    version = "0.0.1";
    src = ./gui;
    installPhase = ''
      mkdir -p $out
      cp wallpaper.jpg $out/wallpaper.jpg
    '';
  };
in

{
  # Allow XDG linking
  xdg.enable = true;

  xdg.dataFile."wallpaper.jpg".source = "${wallpaper}/wallpaper.jpg";
  
  home.packages = with pkgs; [
    discord
    filezilla
    gnome3.gucharmap
    gnome3.meld
    google-chrome
    libnotify
    pavucontrol
    peek
    remmina
    slack-dark
    spotify
    teams
  ];

  gtk = {
    enable = true;

    theme = {
      package = pkgs.arc-theme;
      name = "Arc-Darker";
    };

    iconTheme = {
      package = pkgs.arc-icon-theme;
      name = "Arc";
    };
  };

  qt = {
    enable = true;
    platformTheme = "gtk";
  };
}
