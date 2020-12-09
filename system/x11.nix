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
    desktopManager.xfce.enable = true;

    displayManager.lightdm = {
      enable = true;

      greeters.gtk.indicators = [
        "~host"
        "~spacer"
        "~clock"
        "~spacer"
        "~session"
        "~power"
      ];
    };
  };

  environment.systemPackages = with pkgs; [
    #mate.mate-tweak
    xfce.xfce4-whiskermenu-plugin
  ];
}
