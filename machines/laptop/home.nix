{ config, pkgs, ... }:

{
  _module.args.secrets = import ../../secrets.nix;

  imports = [
    ../../roles/hm/base
    ../../roles/hm/xfce
  ];

  home.stateVersion = "19.09";
}
