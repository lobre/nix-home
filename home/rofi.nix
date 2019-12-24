{ config, pkgs, ... }:

{
  programs.rofi = {
    enable = true;
    borderWidth = null;
    font = "M+ 1mn 12";
    lines = 12;
    padding = 18;
    width = 60;
    location = "center";
    scrollbar = false;
    terminal = "\${pkgs.rxvt_unicode}/bin/urxvt";

    colors = {
      window = {
        background = "#2e3440";
        border = "#2e3440";
        separator = "#2e3440";
      };

      rows = {
        normal = {
          background = "#2e3440";
          foreground = "#d8dee9";
          backgroundAlt = "#2e3440";
          highlight = {
            background = "#2e3440";
            foreground = "#bf616a";
          };
        };

        active = {
          background = "#2e3440";
          foreground = "#b48ead";
          backgroundAlt = "#2e3440";
          highlight = {
            background = "#2e3440";
            foreground = "#93e5cc";
          };
        };

        urgent = {
          background = "#2e3440";
          foreground = "#ebcb8b";
          backgroundAlt = "#2e3440";
          highlight = {
            background = "#2e3440";
            foreground = "#ebcb8b";
          };
        };
      };
    };
  };
}
