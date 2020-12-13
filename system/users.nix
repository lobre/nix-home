{ config, pkgs, ... }:

{
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
    };
  };

  security.sudo.wheelNeedsPassword = false;
}
