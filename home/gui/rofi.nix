{ config, pkgs, ... }:

let
  theme = config.theme;
in

{
  programs.rofi = {
    enable = true;
    borderWidth = null;
    font = "${theme.font.family} 12";
    lines = 12;
    padding = 18;
    width = 60;
    location = "center";
    scrollbar = false;
    terminal = "${pkgs.rxvt_unicode}/bin/urxvt";

    colors = {
      window = {
        background = "${theme.colors.foreground}";
        border = "${theme.colors.foreground}";
        separator = "${theme.colors.foreground}";
      };

      rows = {
        normal = {
          background = "${theme.colors.foreground}";
          foreground = "${theme.colors.foreground}";
          backgroundAlt = "${theme.colors.foreground}";
          highlight = {
            background = "${theme.colors.foreground}";
            foreground = "${theme.colors.color4}";
          };
        };

        active = {
          background = "${theme.colors.foreground}";
          foreground = "${theme.colors.color4}";
          backgroundAlt = "${theme.colors.foreground}";
          highlight = {
            background = "${theme.colors.foreground}";
            foreground = "${theme.colors.color4}";
          };
        };

        urgent = {
          background = "${theme.colors.foreground}";
          foreground = "${theme.colors.urgent}";
          backgroundAlt = "${theme.colors.foreground}";
          highlight = {
            background = "${theme.colors.foreground}";
            foreground = "${theme.colors.urgent}";
          };
        };
      };
    };

    extraConfig = ''
      rofi.kb-row-up: Up,Control+p
      rofi.kb-row-down: Down,Control+n
      rofi.monitor: -1
    '';
  };
}
