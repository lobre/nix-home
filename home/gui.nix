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
    firefox 
    gnome3.eog
    gnome3.gnome-control-center
    gnome3.gucharmap
    gnome3.meld
    gnome3.sushi
    google-chrome
    libnotify
    lxappearance
    mattermost-desktop
    networkmanager
    obsidian
    pantheon.elementary-files
    pavucontrol
    peek
    remmina
    shutter
    skype
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

  imports = [
    ./gui/i3.nix
    ./gui/i3status.nix
    ./gui/rofi.nix
    ./gui/greenclip.nix
    ./gui/alacritty.nix
    ./gui/xresources.nix
    ./gui/picom.nix
    ./gui/dunst.nix
    ./gui/oni2.nix
    ./gui/sway.nix
    ./gui/swaylock.nix
    ./gui/mako.nix
    ./gui/wofi.nix
  ];
}
