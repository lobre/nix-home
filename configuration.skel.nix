# This is a configuration skeleton that can act as a starting point 
# when installing a NixOS system.

{ config, pkgs, ... }:

{
  imports = 
    [
      # results of the hardware scan
      ./hardware-configuration.nix

      # personal configuration
      ./system/main.nix)
      ./system/users.nix)
      #./system/zfs.nix)
      #./system/x11.nix)
      #./system/vmware.nix)
    ];

  # for efi
  #boot.loader.systemd-boot.enable = true;
  #boot.loader.efi.canTouchEfiVariables = true;

  # for bios (replace with disk where grub installed)
  #boot.loader.grub.device = "/dev/disk/by-id/wwn-0x500001234567890a";

  # networking id needed by zfs (head -c 8 /etc/machine-id)
  #networking.hostId = "238330f5";

  # hashed passwords of users
  # :r! mkpasswd -m sha-512
  # or :term on neovim
  users.users = {
    #lobre.hashedPassword = "";
  };

  system.stateVersion = "20.03";
}
