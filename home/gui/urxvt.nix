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
      termName = "rxvt-256color";
      url-launcher = "${pkgs.google-chrome}/bin/google-chrome-stable";
      underlineURLs = true;
      internalBorder = 24;
      externalBorder = 0;
      perl-ext-common = "keyboard-select,matcher,resize-font";
      fading = 5;
      intensityStyles = false;
      mouseWheelScrollPage = false;
      cursorBlink = true;
      urgentOnBell = true;
      visualBell = false;
      boldFont = "xft:${theme.font}:bold:size=12";
      italicFont = "xft:${theme.font}:italic:size=12";
      boldItalicFont = "xft:${theme.font}:bold italic:size=12";
    };
  };

  home.file.".urxvt/ext/keyboard-select".source = ./urxvt/ext/keyboard-select;
  home.file.".urxvt/ext/resize-font".source = ./urxvt/ext/resize-font;
}
