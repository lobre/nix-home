{ config, pkgs, ... }:

let
  theme = config.theme;
in

{
  xresources.properties = {
    # special 
    "*.foreground" = "#d8dee8";
    "*.background" = "#2f343f";
    "*.cursorColor" = "#b48ead";

    # black
    "*.color0" = "#4b5262";
    "*.color8" = "#434a5a";

    # red
    "*.color1" = "#bf616a";
    "*.color9" = "#b3555e";
    
    # green
    "*.color2" = "#a3be8c";
    "*.color10" = "#93ae7c";
    
    # yellow
    "*.color3" = "#ebcb8b";
    "*.color11" = "#dbbb7b";
    
    # blue
    "*.color4" = "#81a1c1";
    "*.color12" = "#7191b1";
    
    # magenta
    "*.color5" = "#b48ead";
    "*.color13" = "#a6809f";
    
    # cyan
    "*.color6" = "#89d0ba";
    "*.color14" = "#7dbba8";
    
    # white
    "*.color7" = "#e5e9f0";
    "*.color15" = "#d1d5dc";
    
    # xft font configuration
    "Xft.autohint" = 0;
    "Xft.lcdfilter" = "lcddefault";
    "Xft.hintstyle" = "hintslight";
    "Xft.hinting" = 1;
    "Xft.antialias" = 1;
    "Xft.rgba" = "rgb";
  };
}
