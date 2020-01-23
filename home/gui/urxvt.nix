{ config, pkgs, ... }:

let
  theme = config.theme;
in

{
  programs.urxvt = {
    enable = true;
    fonts = [ "xft:${theme.font}:regular:size=12" ];
    iso14755 = false;

    scroll = {
      bar.enable = false;
      lines = 50000;
      keepPosition = true;
      scrollOnKeystroke = true;
      scrollOnOutput = false;
    };

    shading = 100;
    transparent = false;
    keybindings = {
      "M-g" = "perl:keyboard-select:activate";
    };

    extraConfig = {
      "keyboard-select.clipboard" = true;
      boldFont = "xft:${theme.font}:bold:size=12";
      boldItalicFont = "xft:${theme.font}:bold italic:size=12";
      cursorBlink = true;
      externalBorder = 0;
      fading = 5;
      intensityStyles = false;
      internalBorder = 24;
      italicFont = "xft:${theme.font}:italic:size=12";
      letterSpace = 1;
      mouseWheelScrollPage = false;
      perl-ext-common = "keyboard-select,matcher,resize-font";
      termName = "rxvt-256color";
      underlineURLs = true;
      urgentOnBell = true;
      url-launcher = "${pkgs.google-chrome}/bin/google-chrome-stable";
      visualBell = false;
    };
  };

  home.file.".urxvt/ext/keyboard-select".source = ./urxvt/ext/keyboard-select;
  home.file.".urxvt/ext/resize-font".source = ./urxvt/ext/resize-font;
}
