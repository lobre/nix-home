{ config, pkgs, secrets, ... }:

{
  imports = [ <home-manager/nixos> ];

  users = {
    mutableUsers = false;

    users.lobre = {
      isNormalUser = true;
      home = "/home/lobre";
      createHome = true;
      description = "Loric Brevet";
      uid = 1000;
      shell = pkgs.bash;
      extraGroups = [ "wheel" "networkmanager" "audio" "video" "docker" ];

      hashedPassword = secrets.hashedPassword;
      openssh.authorizedKeys.keys = secrets.ssh.publicKeys;
    };
  };

  home-manager.useUserPackages = true;
  home-manager.useGlobalPkgs = true;
  home-manager.users.lobre = import ../../hm/base { inherit config pkgs secrets; };

  security.sudo.wheelNeedsPassword = false;
}
