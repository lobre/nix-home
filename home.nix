{ config, pkgs, ... }:

{
  imports = [
    ./home/main.nix
    ./home/gui.nix
  ];
}
