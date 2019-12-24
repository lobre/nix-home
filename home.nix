{ config, pkgs, ... }:

{
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  home.keyboard.layout = "fr";
  home.keyboard.variant = "bepo";

  home.packages = with pkgs; [
    xcwd
  ];

  gtk = {
    enable = true;
    font = {
      name = "M+ 1mn 12";
      package = pkgs.mplus-outline-fonts;
    };

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

  services.random-background = {
    enable = true;
    enableXinerama = true;
    display = "fill";
    imageDirectory = "%h/Pictures/Wallpapers";
    interval = "20min";
  };

  xdg.enable = true;

  fonts.fontconfig.enable = true;
  xdg.dataFile."fonts".source = ./fonts;

  xsession.enable = true;

  imports = [
    ./home/i3.nix
    ./home/i3status.nix
    ./home/rofi.nix
    ./home/urxvt.nix
    ./home/xresources.nix
    ./home/compton.nix
  ];
}
