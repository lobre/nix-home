{ config, pkgs, lib, ... }:

{
  # enable an OpenSSH server during the initrd boot
  boot.initrd.network = {
    enable = true;
    ssh = {
      enable = true;
      port = 2222;
      # this includes the ssh keys of all users in the wheel group
      authorizedKeys = with lib; concatLists (mapAttrsToList (name: user: if elem "wheel" user.extraGroups then user.openssh.authorizedKeys.keys else []) config.users.users);
    };
  };
  
  # Enable regular OpenSSH server
  services.sshd.enable = true;
}
