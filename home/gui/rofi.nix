{ config, pkgs, ... }:

let
  colors = import ./colors.nix;

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
  home.packages = [ run clipboard ];

  programs.rofi = {
    enable = true;
    package = pkgs.rofi.override { plugins = [ pkgs.rofi-calc ]; };

    borderWidth = null;
    font = "monospace 10";
    lines = 12;
    padding = 18;
    width = 50;
    location = "center";
    scrollbar = false;
    terminal = "${config.programs.alacritty.package}/bin/alacritty";

    colors = {
      window = {
        background = "${colors.gray-800}";
        border = "${colors.gray-700}";
        separator = "${colors.gray-700}";
      };

      rows = {
        normal = {
          background = "${colors.gray-800}";
          foreground = "${colors.gray-100}";
          backgroundAlt = "${colors.gray-800}";
          highlight = {
            background = "${colors.gray-800}";
            foreground = "${colors.blue-300}";
          };
        };

        active = {
          background = "${colors.gray-800}";
          foreground = "${colors.blue-300}";
          backgroundAlt = "${colors.gray-800}";
          highlight = {
            background = "${colors.gray-800}";
            foreground = "${colors.blue-300}";
          };
        };

        urgent = {
          background = "${colors.gray-800}";
          foreground = "${colors.red-800}";
          backgroundAlt = "${colors.gray-800}";
          highlight = {
            background = "${colors.gray-800}";
            foreground = "${colors.red-800}";
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
