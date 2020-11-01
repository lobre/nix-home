{ config, pkgs, ... }:

let
  colors = import ./colors.nix;

  themeXresources = pkgs.writeScriptBin "theme-xresources" ''
    #!${pkgs.stdenv.shell}

    cat << EOF
    ! To help importing the current theme into
    ! https://terminal.sexy/
    
    ! special"
    *.foreground: ${config.programs.alacritty.settings.colors.primary.foreground}
    *.background: ${config.programs.alacritty.settings.colors.primary.background}

    ! black
    *.color0:     ${config.programs.alacritty.settings.colors.normal.black}
    *.color8:     ${config.programs.alacritty.settings.colors.bright.black}

    ! red
    *.color1:     ${config.programs.alacritty.settings.colors.normal.red}
    *.color9:     ${config.programs.alacritty.settings.colors.bright.red}

    ! green
    *.color2:     ${config.programs.alacritty.settings.colors.normal.green}
    *.color10:    ${config.programs.alacritty.settings.colors.bright.green}

    ! yellow
    *.color3:     ${config.programs.alacritty.settings.colors.normal.yellow}
    *.color11:    ${config.programs.alacritty.settings.colors.bright.yellow}

    ! blue
    *.color4:     ${config.programs.alacritty.settings.colors.normal.blue}
    *.color12:    ${config.programs.alacritty.settings.colors.bright.blue}

    ! magenta
    *.color5:     ${config.programs.alacritty.settings.colors.normal.magenta}
    *.color13:    ${config.programs.alacritty.settings.colors.bright.magenta}

    ! cyan
    *.color6:     ${config.programs.alacritty.settings.colors.normal.cyan}
    *.color14:    ${config.programs.alacritty.settings.colors.bright.cyan}

    ! white
    *.color7:     ${config.programs.alacritty.settings.colors.normal.white}
    *.color15:    ${config.programs.alacritty.settings.colors.bright.white}
    EOF

  '';
in

{
  home.packages = [ themeXresources ];

  programs.alacritty = {
    enable = true;

    settings = {
      window = {
        padding = {
          x = 30;
          y = 30;
        };  

        title = "Alacritty";
      }; 

      scrolling.history = 10000;

      colors = {
        primary = {
          background = "${colors.gray-800}";
          foreground = "${colors.gray-100}";
        };

        normal = {
          black = "${colors.gray-600}";
          red = "${colors.red-400}";
          green = "${colors.green-300}";
          yellow = "${colors.yellow-300}";
          blue = "${colors.blue-300}";
          magenta = "${colors.purple-300}";
          cyan = "${colors.teal-300}";
          white = "${colors.gray-200}";
        };

        bright = {
          black = "${colors.gray-700}";
          red = "${colors.red-500}";
          green = "${colors.green-400}";
          yellow = "${colors.yellow-400}";
          blue = "${colors.blue-400}";
          magenta = "${colors.purple-400}";
          cyan = "${colors.teal-400}";
          white = "${colors.gray-300}";
        };

        cursor.cursor = "${colors.gray-100}";
        vi_mode_cursor.cursor = "${colors.gray-100}";
      };

      background_opacity = 1;

      # To help find keys, use "alacritty --print-events"
      key_bindings = [
        {
          key = "N";
          mods = "Control|Shift";
          action = "SpawnNewInstance";
        }
        {
          key = "Equals";
          mods = "Control";
          action = "ResetFontSize";
        }
        {
          key = "Key7";
          mods = "Control";
          action = "IncreaseFontSize";
        }
        {
          key = "Key8";
          mods = "Control";
          action = "DecreaseFontSize";
        }
      ];
    };
  };

  # Set static DPI for consistent font size on different monitors
  home.sessionVariables.WINIT_X11_SCALE_FACTOR = "1";
}
