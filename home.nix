{ config, pkgs, ... }:

{
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  home.keyboard.layout = "fr";
  home.keyboard.variant = "bepo";

  home.packages = with pkgs; [
    arandr
    xcwd
    shutter
    haskellPackages.greenclip
  ];

  # Allow XDG linking
  xdg.enable = true;

  # Enable xsession
  xsession.enable = true;

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

  # Fonts
  fonts.fontconfig.enable = true;
  xdg.dataFile."fonts".source = ./home/fonts;

  # Link scripts
  home.file."bin".source = ./home/bin;

  imports = [
    ./home/i3.nix
    ./home/i3status.nix
    ./home/rofi.nix
    ./home/urxvt.nix
    ./home/xresources.nix
    ./home/compton.nix
    ./home/dunst.nix
  ];
}
