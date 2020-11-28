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

    desktopManager.mate.enable = true;
    displayManager.lightdm.enable = true;
  };
}
