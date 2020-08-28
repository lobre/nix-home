{ config, pkgs, ... }:

{
  services.xserver = {
    enable = true;
    layout = "fr";
    xkbVariant = "bepo";

    displayManager.lightdm = {
      enable = true;
      greeters.gtk = {
        theme.name = "Arc-Darker";
        theme.package = pkgs.arc-theme;
        iconTheme.name = "Arc";
        iconTheme.package = pkgs.arc-icon-theme;
        indicators = [
          "~host"
          "~spacer"
          "~clock"
          "~spacer"
          "~session"
          "~power"
        ];
        extraConfig = ''
          font-name=Fira Code 12
        '';
      };
    };

    windowManager.i3 = {
      enable = true;
      package = pkgs.i3-gaps;
      extraPackages = with pkgs; [
        picom
        i3blocks
        i3lock-fancy
        i3status
        libnotify
        lxappearance
        networkmanagerapplet 
      ];
    };
  };

  # Fonts
  fonts.fonts = with pkgs; [
    fira-code
  ];
}
