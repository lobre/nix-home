{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      /etc/nixos/hardware-configuration.nix
      ./system/users.nix
      ./system/x11.nix
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

  # Allow packages from unfree channels
  nixpkgs.config.allowUnfree = true;

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "20.03"; # Did you read the comment?

}

