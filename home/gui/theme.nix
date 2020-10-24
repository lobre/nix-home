{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.theme;

  wallpaper = pkgs.stdenv.mkDerivation {
    pname = "wallpaper";
    version = "0.0.1";
    src = ./.;
    installPhase = ''
      mkdir -p $out
      cp wallpaper.jpg $out/wallpaper.jpg
    '';
  };

  themeAnsi = pkgs.writeScriptBin "theme-ansi" ''
    #!${pkgs.stdenv.shell}

    echo -e "
    \e[40mDark ${cfg.colors.dark}
    \e[100mDarkAlt ${cfg.colors.darkAlt}

    \e[41mColor1 ${cfg.colors.color1}
    \e[101mColor1Alt ${cfg.colors.color1Alt}

    \e[42mColor2 ${cfg.colors.color2}
    \e[102mColor2Alt ${cfg.colors.color2Alt}

    \e[43mColor3 ${cfg.colors.color3}
    \e[103mColor3Alt ${cfg.colors.color3Alt}

    \e[44mColor4 ${cfg.colors.color4}
    \e[104mColor4Alt ${cfg.colors.color4Alt}

    \e[45mColor5 ${cfg.colors.color5}
    \e[105mColor5Alt ${cfg.colors.color5Alt}

    \e[46mColor6 ${cfg.colors.color6}
    \e[106mColor6Alt ${cfg.colors.color6Alt}

    \e[47mLight ${cfg.colors.light}
    \e[107mlightAlt ${cfg.colors.lightAlt}
    "
  '';

  themeXresources = pkgs.writeScriptBin "theme-xresources" ''
    #!${pkgs.stdenv.shell}

    cat << EOF
    ! To help importing the current theme into
    ! https://terminal.sexy/
    
    ! special"
    *.foreground: ${cfg.colors.foreground}
    *.background: ${cfg.colors.background}

    ! black
    *.color0:     ${cfg.colors.dark}
    *.color8:     ${cfg.colors.darkAlt}

    ! red
    *.color1:     ${cfg.colors.color1}
    *.color9:     ${cfg.colors.color1Alt}

    ! green
    *.color2:     ${cfg.colors.color2}
    *.color10:    ${cfg.colors.color2Alt}

    ! yellow
    *.color3:     ${cfg.colors.color3}
    *.color11:    ${cfg.colors.color3Alt}

    ! blue
    *.color4:     ${cfg.colors.color4}
    *.color12:    ${cfg.colors.color4Alt}

    ! magenta
    *.color5:     ${cfg.colors.color5}
    *.color13:    ${cfg.colors.color5Alt}

    ! cyan
    *.color6:     ${cfg.colors.color6}
    *.color14:    ${cfg.colors.color6Alt}

    ! white
    *.color7:     ${cfg.colors.light}
    *.color15:    ${cfg.colors.lightAlt}
    EOF

  '';
in

{
  options.theme = {
    wallpaper = mkOption {
      type = types.str;
      default = "$HOME/Pictures/wallpaper.jpg";
      description = ''
        Path of wallpaper.
      '';
    };

    font = {
      family = mkOption {
        type = types.str;
        default = "DejaVu Sans";
        description = ''
          Family of the main font.
        '';
      };

      fullname = mkOption {
        type = types.str;
        default = "DejaVu Sans";
        description = ''
          Fullname of the main font.
        '';
      };

      nerd-family = mkOption {
        type = types.str;
        default = "DejaVu Sans Nerd Font";
        description = ''
          Family of alternate font from Nerd Fonts containing icons.
        '';
      };

      package = mkOption {
        type = types.nullOr types.package;
        default = null;
        example = literalExample "pkgs.dejavu_fonts";
        description = ''
          Package providing the font. This package will be installed
          to your profile. If <literal>null</literal> then the font
          is assumed to already be available in your profile.
        '';
      };
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
    home.packages = [ themeAnsi themeXresources ];

    theme = {
      wallpaper = "${wallpaper}/wallpaper.jpg";

      font = {
        family = "Fira Code";
        fullname = "Fira Code Regular";
        nerd-family = "FiraCode Nerd Font Mono";
        package = pkgs.fira-code;
      };

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
