{ config, pkgs, ... }:

let
  theme = config.theme;
in

{
  programs.alacritty = {
    enable = true;

    settings = {
      window = {
        padding = {
          x = 20;
          y = 20;
        };  

        title = "Alacritty";
      }; 

      scrolling.history = 10000;

      font = {
        normal.family = "${theme.font.nerd-family}";
        size = 7; 
      };

      colors = {
        primary = {
          background = "${theme.colors.background}";
          foreground = "${theme.colors.foreground}";
        };

        normal = {
          black = "${theme.colors.dark}";
          red = "${theme.colors.color1}";
          green = "${theme.colors.color2}";
          yellow = "${theme.colors.color3}";
          blue = "${theme.colors.color4}";
          magenta = "${theme.colors.color5}";
          cyan = "${theme.colors.color6}";
          white = "${theme.colors.light}";
        };

        bright = {
          black = "${theme.colors.darkAlt}";
          red = "${theme.colors.color1Alt}";
          green = "${theme.colors.color2Alt}";
          yellow = "${theme.colors.color3Alt}";
          blue = "${theme.colors.color4Alt}";
          magenta = "${theme.colors.color5Alt}";
          cyan = "${theme.colors.color6Alt}";
          white = "${theme.colors.lightAlt}";
        };

        cursor.cursor = "${theme.colors.foreground}";
        vi_mode_cursor.cursor = "${theme.colors.foreground}";
      };

      background_opacity = 1;
    };
  };
}
