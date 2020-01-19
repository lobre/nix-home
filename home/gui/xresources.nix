{ config, pkgs, ... }:

let
  theme = config.theme;
in

{
  xresources.properties = {
    # special 
    "*.foreground" = "${theme.colors.foreground}";
    "*.background" = "${theme.colors.background}";
    "*.cursorColor" = "${theme.colors.foreground}";

    # black
    "*.color0" = "${theme.colors.dark}";
    "*.color8" = "${theme.colors.darkAlt}";

    # red
    "*.color1" = "${theme.colors.color1}";
    "*.color9" = "${theme.colors.color1Alt}";
    
    # green
    "*.color2" = "${theme.colors.color2}";
    "*.color10" = "${theme.colors.color2Alt}";
    
    # yellow
    "*.color3" = "${theme.colors.color3}";
    "*.color11" = "${theme.colors.color3Alt}";
    
    # blue
    "*.color4" = "${theme.colors.color4}";
    "*.color12" = "${theme.colors.color4Alt}";
    
    # magenta
    "*.color5" = "${theme.colors.color5}";
    "*.color13" = "${theme.colors.color5Alt}";
    
    # cyan
    "*.color6" = "${theme.colors.color6}";
    "*.color14" = "${theme.colors.color6Alt}";
    
    # white
    "*.color7" = "${theme.colors.light}";
    "*.color15" = "${theme.colors.lightAlt}";
    
    # xft font configuration
    "Xft.autohint" = 0;
    "Xft.lcdfilter" = "lcddefault";
    "Xft.hintstyle" = "hintslight";
    "Xft.hinting" = 1;
    "Xft.antialias" = 1;
    "Xft.rgba" = "rgb";
  };
}
