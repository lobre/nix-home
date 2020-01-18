{ config, pkgs, ... }:

{
  # Allow XDG linking
  xdg.enable = true;

  imports = [
    ./home/term.nix
    ./home/gui.nix
  ];
}
