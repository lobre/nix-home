{ config, pkgs, ... }:

let
  theme = config.theme;

  # Switch between bepo/azerty
  layoutScript = pkgs.writeScriptBin "rofi-script-layout" ''
    #!${pkgs.stdenv.shell}

    if [ -z $@ ]; then
        echo "bepo"
        echo "azerty"
    else
        if [[ "$@" == "bepo" ]]; then
            ${pkgs.xorg.setxkbmap}/bin/setxkbmap fr -variant bepo
        elif [[ "$@" == "azerty" ]]; then
            ${pkgs.xorg.setxkbmap}/bin/setxkbmap fr
        fi
    fi
  '';

  # Mute/unmute dunst notifications
  dunstScript = pkgs.writeScriptBin "rofi-script-dunst" ''
    #!${pkgs.stdenv.shell}

    if [ -z $@ ]; then
        echo "mute"
        echo "unmute"
    else
        if [[ "$@" == "mute" ]]; then
            notify-send DUNST_COMMAND_PAUSE
        elif [[ "$@" == "unmute" ]]; then
            notify-send DUNST_COMMAND_RESUME
        fi
    fi
  '';

  # Change position of monitors 
  monitorScript = pkgs.writeScriptBin "rofi-script-monitor" ''
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

  # Main rofi wrapper for running application
  mainWrapper = pkgs.writeScriptBin "rofi-run" ''
    #!${pkgs.stdenv.shell}

    ${pkgs.fd}/bin/fd . $HOME | ${config.programs.rofi.package}/bin/rofi \
      -combi-modi 'drun#window' \
      -modi 'calc#combi#file-browser' \
      -display-combi run \
      -sidebar-mode \
      -show combi
  '';

  # Main rofi wrapper for running application
  configWrapper = pkgs.writeScriptBin "rofi-config" ''
    #!${pkgs.stdenv.shell}

    ${config.programs.rofi.package}/bin/rofi \
      -modi 'layout:${layoutScript}/bin/rofi-script-layout#monitor:${monitorScript}/bin/rofi-script-monitor#dunst:${dunstScript}/bin/rofi-script-dunst' \
      -sidebar-mode \
      -show monitor
  '';

  # Rofi wrapper for clipboard manager
  clipboardWrapper = pkgs.writeScriptBin "rofi-clipboard" ''
    #!${pkgs.stdenv.shell}

    ${config.programs.rofi.package}/bin/rofi \
      -modi 'clipboard:${pkgs.haskellPackages.greenclip}/bin/greenclip print' \
      -show clipboard
  '';
in

{
  home.packages = [ mainWrapper configWrapper clipboardWrapper ];

  programs.rofi = {
    enable = true;
    package = pkgs.rofi.override { plugins = [ pkgs.rofi-calc pkgs.rofi-file-browser ]; };

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
    oc-cmd '${config.programs.alacritty.package}/bin/alacritty -e ${config.programs.vim.package}/bin/vim;name:vim;icon:accessories-text-editor'
    oc-cmd '${pkgs.pantheon.elementary-files}/bin/io.elementary.files;name:explorer;icon:system-file-manager'
    oc-cmd '${pkgs.google-chrome}/bin/google-chrome-stable;name:browser;icon:applications-internet'
  '';
}
