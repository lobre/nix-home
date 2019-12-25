{ config, pkgs, ... }:

{
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # Allow XDG linking
  xdg.enable = true;

  imports = [
    ./home/term.nix
  ];
}
