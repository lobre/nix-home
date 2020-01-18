{ config, lib, pkgs, ... }:

with lib;

{
  options.theme = {
    font = mkOption {
      type = types.str;
      default = "DejaVu Sans";
      description = ''
        The main font used in all terminal and graphical applications.
      '';
    };

    colors = {
      background = mkOption {
        type = types.str;
        default = "#000000";
        description = ''
          The background color.
        '';
      };
      foreground = mkOption {
        type = types.str;
        default = "#000000";
        description = ''
          The foreground color.
        '';
      };

      urgent = mkOption {
        type = types.str;
        default = "#000000";
        description = ''
          The urgent color.
        '';
      };

      dark = mkOption {
        type = types.str;
        default = "#000000";
        description = ''
          The dark color.
        '';
      };
      darkAlt = mkOption {
        type = types.str;
        default = "#000000";
        description = ''
          The dark alt color.
        '';
      };

      color1 = mkOption {
        type = types.str;
        default = "#000000";
        description = ''
          The color 1.
        '';
      };
      color1Alt = mkOption {
        type = types.str;
        default = "#000000";
        description = ''
          The color 1 alt.
        '';
      };

      color2 = mkOption {
        type = types.str;
        default = "#000000";
        description = ''
          The color 2.
        '';
      };
      color2Alt = mkOption {
        type = types.str;
        default = "#000000";
        description = ''
          The color 2 alt.
        '';
      };

      color3 = mkOption {
        type = types.str;
        default = "#000000";
        description = ''
          The color 3.
        '';
      };
      color3Alt = mkOption {
        type = types.str;
        default = "#000000";
        description = ''
          The color 3 alt.
        '';
      };

      color4 = mkOption {
        type = types.str;
        default = "#000000";
        description = ''
          The color 4.
        '';
      };
      color4Alt = mkOption {
        type = types.str;
        default = "#000000";
        description = ''
          The color 4 alt.
        '';
      };

      color5 = mkOption {
        type = types.str;
        default = "#000000";
        description = ''
          The color 5.
        '';
      };
      color5Alt = mkOption {
        type = types.str;
        default = "#000000";
        description = ''
          The color 5 alt.
        '';
      };

      color6 = mkOption {
        type = types.str;
        default = "#000000";
        description = ''
          The color 6.
        '';
      };
      color6Alt = mkOption {
        type = types.str;
        default = "#000000";
        description = ''
          The color 6 alt.
        '';
      };

      light = mkOption {
        type = types.str;
        default = "#000000";
        description = ''
          The light color.
        '';
      };
      lightAlt = mkOption {
        type = types.str;
        default = "#000000";
        description = ''
          The light alt color.
        '';
      };
    };
  };

  config = {
    theme = {
      font = "M+ 1mn";

      colors = {
        background = "#2F343F";
        foreground = "#D8DEE8";
        urgent = "#BF616A";

        dark = "#4B5262";
        darkAlt = "#434A5A";

        color1 = "#BF616A";
        color1Alt = "#B3555E";

        color2 = "#A3BE8C";
        color2Alt = "#93AE7C";

        color3 = "#EBCB8B";
        color3Alt = "#DBBB7B";

        color4 = "#81A1C1";
        color4Alt = "#7191B1";

        color5 = "#B48EAD";
        color5Alt = "#A6809F";

        color6 = "#89D0BA";
        color6Alt = "#7DBBA8";

        light = "#E5E9F0";
        lightAlt = "#D1D5DC";
      };
    };
  };
}
