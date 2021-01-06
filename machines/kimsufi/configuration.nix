{ config, pkgs, ... }:

{
  _module.args.secrets = import ../../secrets.nix;

  networking.hostName = "kimsufi";

  # For bios (replace with disk where grub installed)
  boot.loader.grub.device = "/dev/sda";

  imports = [
    ./hardware-configuration.nix
    ../../roles/nixos/base
    ../../roles/nixos/server
  ];

  system.stateVersion = "20.03";
}
