{ config, pkgs, secrets, ... }:

let
  daemonConfig = pkgs.writeText "daemon.json"
    (builtins.toJSON { features = { buildkit = true; }; });

in {
  # No need for predictable names as I usually only have one ethernet and one wireless interfaces
  networking.usePredictableInterfaceNames = false;

  virtualisation.docker.enable = true;
  virtualisation.docker.extraOptions = "--config-file=${daemonConfig}";

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
    mkpasswd
    parted
    pciutils
    unzip
    usbutils
    vim_configurable
    wget
  ];

  nix.gc = {
    automatic = true;
    options = "--delete-older-than 15d";
  };

  nixpkgs.config.allowUnfree = true;

  imports = [ ./users.nix ];
}
