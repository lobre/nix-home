{ config, pkgs, secrets, ... }:

{
  # No need for predictable names as I usually only have one ethernet and one wireless interfaces
  networking.usePredictableInterfaceNames = false;

  virtualisation.docker.enable = true;

  console = {
    font = "Lat2-Terminus16";
    keyMap = "fr-bepo";
  };

  i18n.defaultLocale = "en_GB.UTF-8";

  time.timeZone = "Europe/Paris";

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

  services.tailscale.enable = true;

  nix.gc = {
    automatic = true;
    options = "--delete-older-than 15d";
  };

  nixpkgs.config.allowUnfree = true;

  imports = [
    ./users.nix
  ];
}
