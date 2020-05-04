{ config, pkgs, ... }:

{
  # Touchpad support
  services.xserver.libinput = {
    enable = true;
    naturalScrolling = true;
  };

  # Optimize battery life
  services.tlp.enable = true;

  # Video drivers
  hardware.bumblebee.enable = true;
}
