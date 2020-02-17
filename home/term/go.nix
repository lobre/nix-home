{ config, pkgs, ... }:

{
  programs.go = {
    enable = true;
    goPath = "Lab/go";
  };

  home.sessionVariables.GOROOT = "${pkgs.go}/share/go";
}

