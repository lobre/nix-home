{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      /etc/nixos/hardware-configuration.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.networkmanager.enable = true;
  # No need for predictable names as I usually only have one ethernet and one wireless interfaces
  networking.usePredictableInterfaceNames = false;

  # Internationalisation properties.
  i18n = {
    consoleFont = "Lat2-Terminus16";
    consoleKeyMap = "fr-bepo";
    defaultLocale = "en_GB.UTF-8";
  };

  # Timezone
  time.timeZone = "Europe/Paris";

  # Packages installed in system profile
  environment.systemPackages = with pkgs; [
    acpilight
    curl
    firefox 
    pavucontrol
    unzip
    vim_configurable 
    wget 
  ];

  # Fonts
  fonts.fonts = with pkgs; [
    mplus-outline-fonts
  ];

  # Programs
  programs.dconf.enable = true;
  programs.evince.enable = true;
  programs.file-roller.enable = true;
  programs.zsh.enable = true;

  # Services
  services.gnome3.sushi.enable = true;
  services.pantheon.files.enable = true;

  # Sound
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  # Video drivers
  hardware.bumblebee.enable = true;

  # Brightness control
  hardware.brightnessctl.enable = true;

  # Touchpad support
  services.xserver.libinput.enable = true;

  # Optimize battery life
  services.tlp.enable = true;

  # X11 windowing system.
  services.xserver = {
    enable = true;
    layout = "fr";
    xkbVariant = "bepo";
    xkbOptions = "caps:escape";

    desktopManager = {
      default = "none";
      xterm.enable = false;
    };

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
        font-name=M+ 1mn 12
        '';
      };
    };

    windowManager.i3 = {
      enable = true;
      package = pkgs.i3-gaps;
      extraPackages = with pkgs; [
        compton
        i3blocks
        i3lock-fancy
        i3status
        libnotify
        lxappearance
        networkmanagerapplet 
      ];
    };

  };

  users = {
    mutableUsers = false;

    users.lobre = {
      isNormalUser = true;
      home = "/home/lobre";
      createHome = true;
      description = "Loric Brevet";
      uid = 1000;
      shell = pkgs.zsh;
      extraGroups = [ "wheel" "networkmanager" "audio" "video" ];
      # Generated with:
      # mkpasswd -m sha-512 > /etc/nixos/secrets/lobre-password.txt
      passwordFile = "/etc/nixos/secrets/lobre-password.txt";
    };
  };

  security.sudo.wheelNeedsPassword = false;

  # Allow packages from unfree channels
  nixpkgs.config.allowUnfree = true;

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "20.03"; # Did you read the comment?

}

