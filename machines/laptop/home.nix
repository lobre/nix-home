{ config, pkgs, ... }:

{
  imports = [ ../../roles/hm/base ../../roles/hm/xfce ];

  home.username = "lobre";
  home.homeDirectory = "/home/lobre";

  home.stateVersion = "21.11";
}
