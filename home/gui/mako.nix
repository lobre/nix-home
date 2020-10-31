{ config, pkgs, ... }:

{
  programs.mako = {
    enable = true;
    # expire to 10s
    defaultTimeout = 10000;
  };
}

