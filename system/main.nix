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
  environment.systemPackages = with pkgs; [
    curl
    git
    gptfdisk
    mkpasswd
    parted
    pciutils
    tailscale
    unzip
    usbutils
    vim_configurable
    wget
  ];

  # Programs
  programs.dconf.enable = true;
  programs.evince.enable = true;
  programs.file-roller.enable = true;
  programs.zsh.enable = true;

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

