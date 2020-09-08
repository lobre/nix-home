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

  # Graphical apps
  environment.systemPackages = with pkgs; [
    firefox
    pantheon.elementary-files
    pavucontrol
  ];

  # Services
  services.gnome3.sushi.enable = true;

  # Sound
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  # Touchpad support
  services.xserver.libinput = {
    enable = true;
    naturalScrolling = true;
    # to only affect touchpad and not all input devices
    additionalOptions = ''MatchIsTouchpad "on"'';
  };

  # Brightness
  programs.light.enable = true;

  # Optimize battery life
  services.tlp.enable = true;

  # Video drivers
  hardware.bumblebee.enable = true;

  # Use local time instead of UTC to
  # stay in sync with Windows
  time.hardwareClockInLocalTime = true;
}
