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

  xsession.enable = true;

  imports = [
    ./home/i3.nix
    ./home/rofi.nix
    ./home/urxvt.nix
    ./home/xresources.nix
  ];
}
