{ config, pkgs, lib, ... }:

{
  # Enable OpenSSH server
  services.sshd.enable = true;
}
