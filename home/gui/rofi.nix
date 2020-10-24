{ config, pkgs, ... }:

let
  theme = config.theme;

  # Switch between keyboard layouts
  kb = pkgs.writeScriptBin "rofi-kb" ''
    #!${pkgs.stdenv.shell}

    if [ -z $@ ]; then
        echo "bepo"
        echo "azerty"
        echo "qwerty"
    else
        if [[ "$@" == "bepo" ]]; then
            ${pkgs.xorg.setxkbmap}/bin/setxkbmap fr -variant bepo
        elif [[ "$@" == "azerty" ]]; then
            ${pkgs.xorg.setxkbmap}/bin/setxkbmap fr
        elif [[ "$@" == "qwerty" ]]; then
            ${pkgs.xorg.setxkbmap}/bin/setxkbmap us
        fi
    fi
  '';

  # Do not disturb mode to mute dunst notifications
  dnd = pkgs.writeScriptBin "rofi-dnd" ''
    #!${pkgs.stdenv.shell}

    if [ -z $@ ]; then
        echo "enable"
        echo "disable"
    else
        if [[ "$@" == "enable" ]]; then
            notify-send DUNST_COMMAND_PAUSE
        elif [[ "$@" == "disable" ]]; then
            notify-send DUNST_COMMAND_RESUME
        fi
    fi
  '';

  # Change display of monitors 
  display = pkgs.writeScriptBin "rofi-display" ''
    #!${pkgs.stdenv.shell}

    DIR="$HOME/.screenlayout"

    if [ -z $@ ]; then
        function gen_layouts() {
            for file in $DIR/*
            do
                if [[ -f $file ]]; then
                    file="$(basename -- $file)"
                    echo "$file" | cut -f 1 -d '.'
                fi
            done
        }
        gen_layouts
    else
        layout="$DIR/$@.sh"
        if [[ -f $layout ]]; then
            sh "$layout"
        fi
    fi
  '';

  # Command to reveal rofi
  run = pkgs.writeScriptBin "rofi-run" ''
    #!${pkgs.stdenv.shell}

    ${config.programs.rofi.package}/bin/rofi \
      -modi 'keyboard:${kb}/bin/rofi-kb#display:${display}/bin/rofi-display#combi#calc#do not disturb:${dnd}/bin/rofi-dnd' \
      -combi-modi 'drun#window' \
      -display-combi run \
      -sidebar-mode \
      -show combi
  '';

  # Rofi clipboard manager command
  clipboard = pkgs.writeScriptBin "rofi-clipboard" ''
    #!${pkgs.stdenv.shell}

    ${config.programs.rofi.package}/bin/rofi \
      -modi 'clipboard:${pkgs.haskellPackages.greenclip}/bin/greenclip print' \
      -show clipboard
  '';
in

{
  home.packages = [ run ];

  programs.rofi = {
    enable = true;
    package = pkgs.rofi.override { plugins = [ pkgs.rofi-calc ]; };

    borderWidth = null;
    font = "${theme.font.family} 12";
    lines = 12;
    padding = 18;
    width = 50;
    location = "center";
    scrollbar = false;
    terminal = "${pkgs.rxvt_unicode}/bin/urxvt";

    colors = {
      window = {
        background = "${theme.colors.background}";
        border = "${theme.colors.background}";
        separator = "${theme.colors.background}";
      };

      rows = {
        normal = {
          background = "${theme.colors.background}";
          foreground = "${theme.colors.foreground}";
          backgroundAlt = "${theme.colors.background}";
          highlight = {
            background = "${theme.colors.background}";
            foreground = "${theme.colors.color4}";
          };
        };

        active = {
          background = "${theme.colors.background}";
          foreground = "${theme.colors.color4}";
          backgroundAlt = "${theme.colors.background}";
          highlight = {
            background = "${theme.colors.background}";
            foreground = "${theme.colors.color4}";
          };
        };

        urgent = {
          background = "${theme.colors.background}";
          foreground = "${theme.colors.urgent}";
          backgroundAlt = "${theme.colors.background}";
          highlight = {
            background = "${theme.colors.background}";
            foreground = "${theme.colors.urgent}";
          };
        };
      };
    };

    extraConfig = ''
      rofi.kb-row-up: Up,Control+p
      rofi.kb-row-down: Down,Control+n
      rofi.monitor: -1
      rofi.show-icons: true
      rofi.matching: glob
    '';
  };

  # file browser configuration
  xdg.configFile."rofi/file-browser".text = ''
    stdin
    oc-cmd '${config.programs.alacritty.package}/bin/alacritty --working-directory;name:terminal;icon:utilities-terminal'
    oc-cmd '${config.programs.alacritty.package}/bin/alacritty -e ${config.programs.neovim.package}/bin/nvim;name:vim;icon:accessories-text-editor'
    oc-cmd '${pkgs.pantheon.elementary-files}/bin/io.elementary.files;name:explorer;icon:system-file-manager'
    oc-cmd '${pkgs.google-chrome}/bin/google-chrome-stable;name:browser;icon:applications-internet'
  '';
}
