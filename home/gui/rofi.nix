{ config, pkgs, ... }:

let
  theme = config.theme;
in

{
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
    '';
  };

  # file browser configuration
  xdg.configFile."rofi/file-browser".text = ''
    oc-cmd '${pkgs.pantheon.elementary-files}/bin/io.elementary.files;name:explorer;icon:system-file-manager'
    oc-cmd '${config.programs.alacritty.package}/bin/alacritty --working-directory;name:terminal;icon:utilities-terminal'
    oc-cmd '${config.programs.alacritty.package}/bin/alacritty -e ${config.programs.vim.package}/bin/vim;name:vim;icon:accessories-text-editor'
    oc-cmd '${pkgs.google-chrome}/bin/google-chrome-stable;name:browser;icon:applications-internet'
  '';
}
