{ config, pkgs, ... }:

{
  virtualisation.vmware.guest.enable = true;

  # Packages installed in system profile
  environment.systemPackages = with pkgs; [
    open-vm-tools
  ];
}
