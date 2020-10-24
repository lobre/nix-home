{ config, pkgs, ... }:

{
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  imports = [
    ./home/config.nix
    ./home/term.nix
    #./home/gui.nix
    #./home/non-nixos.nix
  ];

  home.stateVersion = "19.09";
}
