{ config, pkgs, ... }:

{
  programs.go = {
    enable = true;
    goPath = "${config.home.homeDirectory}/Lab/go";
  };

  home.sessionVariables.GOROOT = "${pkgs.go}/share/go/src";
}

