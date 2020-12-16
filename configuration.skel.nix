# This is a configuration skeleton that can act as a starting point 
# when installing a NixOS system.

{ config, pkgs, ... }:

{
  imports = 
    [
      # results of the hardware scan
      ./hardware-configuration.nix

      # personal configuration
      ./system/main.nix
      ./system/users.nix
      #./system/server.nix
      #./system/x11.nix
      #./system/drivers.nix
      #./system/vmware.nix
    ];

  # For efi
  #boot.loader.systemd-boot.enable = true;
  #boot.loader.efi.canTouchEfiVariables = true;

  # For bios (replace with disk where grub installed)
  #boot.loader.grub.device = "/dev/sda";
  
  users.users.lobre = {
    # Hashed password of user
    # :r! mkpasswd -m sha-512
    # or :term on neovim
    #hashedPassword = "";
    
    #openssh.authorizedKeys.keys = [ "ssh-rsa AAAA... loric" ];
  };

  # hostname of machine
  #networking.hostName = "nixos";

  system.stateVersion = "20.03";
}
