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
  xdg.enable = true;
  home.file."Pictures/Wallpapers/wallpaper.jpg".source = "${wallpaper}/wallpaper.jpg";
  
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
      package = pkgs.papirus-icon-theme;
      name = "ePapirus";
    };
  };

  qt = {
    enable = true;
    platformTheme = "gtk";
  };
}
