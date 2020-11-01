{ config, pkgs, ... }:

let
  colors = import ./colors.nix;
in

{
  programs.mako = {
    enable = true;
    anchor = "top-right";
    backgroundColor = "${colors.gray-900}";
    borderColor = "${colors.gray-800}";
    textColor = "${colors.gray-100}";
    borderSize = 2;
    font = "monospace 10";
    layer = "top";
    margin = "10";
    padding = "5";
    defaultTimeout = 6000;
  };
}

