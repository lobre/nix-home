{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    xfce.xfce4-appfinder
    xfce.xfce4-clipman-plugin
    xfce.xfce4-screenshooter
    xfce.xfce4-taskmanager
    xfce.xfce4-terminal
  ];

  imports = [
    ./xfce/terminal.nix
  ];
}

