{ config, pkgs, ... }:

{
  # Enable settings that make home manager work better on Linux distribs other than NixOS
  targets.genericLinux.enable = true;

  imports = [ ./roles/hm/base ./roles/hm/xfce ];

  home.username = "brevetl";
  home.homeDirectory = "/home/brevetl";

  home.stateVersion = "21.11";
}
