{ config, pkgs, ... }:

{
  # Network Manager is a high level interface
  # to automatically configure the network.
  # It comes with opinionated configurations
  # which don't always play well with server setups.
  # That's why it is only enabled alongside x11 configs.
  networking.networkmanager.enable = true;

  services.xserver = {
    enable = true;
    layout = "fr";
    xkbVariant = "bepo";

    displayManager = {
      gdm.enable = true;

      # Default X session that will defer to ~/.xsession
      session = [
         {
           manage = "desktop";
           name = "Xsession";
           start = "";
         }
      ];

      # Use X session by default instead of sway
      defaultSession = "Xsession";
    };
  };

  # This will add a wayland desktop entry
  # that will be available to the login manager
  programs.sway.enable = true;
}
