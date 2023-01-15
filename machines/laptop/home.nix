{ config, pkgs, ... }:

{
  imports = [ ../../roles/hm/base ../../roles/hm/xfce ];

  home.stateVersion = "21.11";
}
