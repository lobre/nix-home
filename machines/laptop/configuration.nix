{ config, pkgs, ... }:

let
  # script to launch a program with enabled nvidia card
  nvidia-offload = pkgs.writeShellScriptBin "nvidia-offload" ''
    export __NV_PRIME_RENDER_OFFLOAD=1
    export __NV_PRIME_RENDER_OFFLOAD_PROVIDER=NVIDIA-G0
    export __GLX_VENDOR_LIBRARY_NAME=nvidia
    export __VK_LAYER_NV_optimus=NVIDIA_only
    exec -a "$0" "$@"
  '';

in
{
  environment.systemPackages = [ nvidia-offload ];

  networking.hostName = "laptop";

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Sound
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  # Touchpad support
  services.xserver.libinput = {
    enable = true;
    touchpad = {
      naturalScrolling = true;
      # to only affect touchpad and not all input devices
      additionalOptions = ''MatchIsTouchpad "on"'';
    };
  };

  # Brightness
  programs.light.enable = true;

  # Optimize battery life
  services.tlp.enable = true;

  # Video drivers
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia.prime = {
    offload.enable = true;
    # Bus IDs of NVIDIA and Intel GPUs.
    # Use lspci and transform as explained in https://nixos.wiki/wiki/Nvidia
    intelBusId = "PCI:0:2:0";
    nvidiaBusId = "PCI:2:0:0";
  };

  # Use local time instead of UTC to stay in sync with Windows
  time.hardwareClockInLocalTime = true;

  # Yubikey
  services.udev.packages = [ pkgs.yubikey-personalization ];
  services.pcscd.enable = true;

  imports = [
    ./hardware-configuration.nix
    ../../roles/nixos/base
    ../../roles/nixos/x11
  ];

  system.stateVersion = "21.11";
}
