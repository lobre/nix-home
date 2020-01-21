{ config, pkgs, ... }:

{
  # Allow XDG linking
  xdg.enable = true;

  imports = [
    ./home/non-nixos.nix
    ./home/term.nix
  ];
}
