{ config, pkgs, ... }:

{
  # Touchpad support
  services.xserver.libinput = {
    enable = true;
    naturalScrolling = true;
    # to only affect touchpad and not all input devices
    additionalOptions = ''MatchIsTouchpad "on"'';
  };

  # Optimize battery life
  services.tlp.enable = true;

  # Video drivers
  hardware.bumblebee.enable = true;
}
