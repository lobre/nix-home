{ config, pkgs, ... }:

{
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
