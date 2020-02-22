{ config, pkgs, ... }:

{
  programs.go = {
    enable = true;
    package = pkgs.go_1_13;
    goPath = "Lab/go";
  };

  home.sessionVariables.GOROOT = "${pkgs.go}/share/go";
}

