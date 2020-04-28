{ config, pkgs, ... }:

{
  services.picom = {
    enable = true;
    backend = "xrender";
    blur = false;
    noDNDShadow = true;
    noDockShadow = true;
    refreshRate = 0;
    vSync = false;

    # opacity
    activeOpacity = "1.0";
    inactiveOpacity = "1.0";
    menuOpacity = "1.0";

    # fading
    fade = true;
    fadeDelta = 1;
    fadeSteps = [ "0.02" "0.02" ];

    # shadow
    shadow = true;
    shadowOffsets = [ (-12) (-12) ];
    shadowOpacity = "0.95";
    shadowExclude = [ "class_g = 'i3-frame'" ];

    extraOptions = ''
      mark-wmwin-focused = true;
      mark-ovredir-focused = true;
      detect-rounded-corners = true;
      detect-client-opacity = true;
      detect-transient = true;
      detect-client-leader = true;
    '';
  };
}
