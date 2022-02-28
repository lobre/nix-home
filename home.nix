{ config, pkgs, ... }:

{
  _module.args.secrets = import ./secrets.nix;

  # Enable settings that make home manager work better on Linux distribs other than NixOS
  targets.genericLinux.enable = true;

  imports = [
    ./roles/hm/base
    ./roles/hm/xfce
  ];

  home.stateVersion = "21.11";
}
