{ config, pkgs, ... }:

{
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  home.keyboard.layout = "fr";
  home.keyboard.variant = "bepo";

  home.packages = [
    pkgs.xcwd
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

  xsession.windowManager.i3 = import ./home/i3.nix;
}
