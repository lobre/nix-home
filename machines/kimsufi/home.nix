{ config, pkgs, ... }:

{
  _module.args.secrets = import ../../secrets.nix;

  imports = [
    ../../roles/hm/base
  ];

  home.stateVersion = "19.09";
}
