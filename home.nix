{ config, pkgs, ... }:

{
  imports = [
    ./home/term.nix
    ./home/gui.nix
  ];
}
