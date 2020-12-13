{ config, pkgs, ... }:

{
  # No need for predictable names as I usually only have one ethernet and one wireless interfaces
  networking.usePredictableInterfaceNames = false;

  # Enable docker
  virtualisation.docker.enable = true;

  # Internationalisation properties.
  console = {
    font = "Lat2-Terminus16";
    keyMap = "fr-bepo";
  };
  i18n.defaultLocale = "en_GB.UTF-8";

  # Timezone
  time.timeZone = "Europe/Paris";

  # Packages installed in system profile
  # It should only contain packages that
  # will be used during install. User packages
  # can be installed by users themselves.
  environment.systemPackages = with pkgs; [
    curl
    git
    gptfdisk
    htop
    mkpasswd
    parted
    pciutils
    tailscale
    unzip
    usbutils
    vim_configurable
    wget
  ];

  # Services
  services.tailscale.enable = true;

  # Garbage collection
  nix.gc = {
    automatic = true;
    options = "--delete-older-than 15d";
  };

  # Allow packages from unfree channels
  nixpkgs.config.allowUnfree = true;
}

