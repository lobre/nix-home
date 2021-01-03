{ config, pkgs, ... }:

{
  _module.args.secrets = import ../../secrets.nix;

  networking.hostName = "laptop";

  # EFI?

  # Sound
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  # Touchpad support
  services.xserver.libinput = {
    enable = true;
    naturalScrolling = true;
    # to only affect touchpad and not all input devices
    additionalOptions = ''MatchIsTouchpad "on"'';
  };

  # Brightness
  programs.light.enable = true;

  # Optimize battery life
  services.tlp.enable = true;

  # Video drivers
  hardware.bumblebee.enable = true;

  # Use local time instead of UTC to
  # stay in sync with Windows
  time.hardwareClockInLocalTime = true;

  imports = [
    ./hardware-configuration.nix
    ../../roles/nixos/base
    ../../roles/nixos/x11
  ];

  system.stateVersion = "20.03";
}
