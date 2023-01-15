{ config, pkgs, ... }:

{
  imports = [ ../../roles/hm/base ];

  home.stateVersion = "21.11";
}
