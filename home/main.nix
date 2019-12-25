{ config, pkgs, ... }:

{
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # Allow XDG linking
  xdg.enable = true;

  home.packages = with pkgs; [
    curl
    git
    htop 
    tree
    unzip
    vim_configurable 
    wget 
  ];

  imports = [
  ];
}
