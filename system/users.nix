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
      shell = pkgs.zsh;
      extraGroups = [ "wheel" "networkmanager" "audio" "video" "docker" ];
      # Generated with:
      # mkpasswd -m sha-512 > /etc/nixos/secrets/lobre-password.txt
      passwordFile = "/etc/nixos/secrets/lobre-password.txt";
    };
  };

  security.sudo.wheelNeedsPassword = false;
}
