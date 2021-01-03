{ config, pkgs, ... }:

{
  _module.args.secrets = import ../../secrets.nix;

  networking.hostName = "kimsufi";

  # For bios (replace with disk where grub installed)
  boot.loader.grub.device = "/dev/sda";

  services.sshd.enable = true;

  imports = [
    ./hardware-configuration.nix
    ../../roles/nixos/base
  ];

  system.stateVersion = "20.03";
}
