{ config, pkgs, ... }:

{
  imports = [ ../../roles/hm/base ];

  home.username = "lobre";
  home.homeDirectory = "/home/lobre";

  home.stateVersion = "21.11";
}
