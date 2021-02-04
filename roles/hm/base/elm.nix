{ pkgs, ... }:

{
  home.packages = with pkgs; [
    elmPackages.elm
    elmPackages.elm-test
    elmPackages.elm-format
  ];
}


