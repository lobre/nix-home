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
    xkbVariant = "bepo_afnor";

    desktopManager.xfce.enable = true;

    displayManager.lightdm = {
      enable = true;

      greeters.gtk.indicators =
        [ "~host" "~spacer" "~clock" "~spacer" "~session" "~power" ];
    };
  };

  programs.thunar = {
    enable = true;
    plugins = with pkgs.xfce; [ thunar-archive-plugin thunar-volman ];
  };

  programs.file-roller.enable = true;

  # additional xfce packages
  environment.systemPackages = with pkgs; [
    xfce.gigolo
    xfce.orage
    xfce.xfburn
    xfce.xfce4-battery-plugin
    xfce.xfce4-clipman-plugin
    xfce.xfce4-cpufreq-plugin
    xfce.xfce4-cpugraph-plugin
    xfce.xfce4-datetime-plugin
    xfce.xfce4-dict
    xfce.xfce4-fsguard-plugin
    xfce.xfce4-genmon-plugin
    xfce.xfce4-mailwatch-plugin
    xfce.xfce4-mpc-plugin
    xfce.xfce4-netload-plugin
    xfce.xfce4-notes-plugin
    xfce.xfce4-sensors-plugin
    xfce.xfce4-systemload-plugin
    xfce.xfce4-timer-plugin
    xfce.xfce4-verve-plugin
    xfce.xfce4-weather-plugin
    xfce.xfce4-whiskermenu-plugin
    xfce.xfce4-xkb-plugin
  ];
}

