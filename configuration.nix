# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # networking.hostName = "nixos"; # Define your hostname.
  # Enables wireless support via wpa_supplicant.
  # Configure wireless networks using:
  # wpa_passphrase ESSID PSK > /etc/wpa_supplicant.conf
  #networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true;

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  #networking.interfaces.wlo1.useDHCP = true;
  #networking.interfaces.enp0s20f0u4.useDHCP = true;

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n = {
    consoleFont = "Lat2-Terminus16";
    consoleKeyMap = "fr-bepo";
    defaultLocale = "en_GB.UTF-8";
  };

  # Set your time zone.
  time.timeZone = "Europe/Paris";

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    wget 
    unzip
    curl
    git
    lxappearance
    vim_configurable 
    pavucontrol
    networkmanagerapplet 
    acpilight
    firefox 
    arc-theme
    arc-icon-theme
    htop 
    rxvt_unicode 
    google-chrome
    compton
    spotify
  ];

  # Fonts
  fonts.fonts = with pkgs; [
    noto-fonts
    mplus-outline-fonts
    font-awesome
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  #   pinentryFlavor = "gnome3";
  # };
  programs.zsh.enable = true;

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  # Video drivers
  hardware.bumblebee.enable = true;

  # Allow brightness control
  hardware.brightnessctl.enable = true;

  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;
    layout = "fr";
    xkbVariant = "bepo";
    xkbOptions = "caps:escape";
    #autorun = false;

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
      };
    };

    windowManager.i3 = {
      enable = true;
      package = pkgs.i3-gaps;
      extraPackages = with pkgs; [
        dmenu
        i3status
        i3lock
        i3blocks
      ];
    };

  };

  # Enable touchpad support.
  services.xserver.libinput.enable = true;

  # Optimize battery life
  services.tlp.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users = {
    mutableUsers = false;

    users.lobre = {
      isNormalUser = true;
      home = "/home/lobre";
      createHome = true;
      description = "Loric Brevet";
      uid = 1000;
      shell = pkgs.zsh;
      extraGroups = [ "wheel" "networkmanager" "audio" "video" ]; # Enable ‘sudo’ for the user.
      # Generated with:
      # mkpasswd -m sha-512 > /etc/nixos/secrets/lobre-password.txt
      passwordFile = "/etc/nixos/secrets/lobre-password.txt";
    };
  };

  security.sudo.wheelNeedsPassword = false;

  nixpkgs.config.allowUnfree = true;

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "20.03"; # Did you read the comment?

}

