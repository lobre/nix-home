{ config, pkgs, ... }:

let
  wallpaper = pkgs.stdenv.mkDerivation {
    pname = "wallpaper";
    version = "0.0.1";
    src = ./.;
    installPhase = ''
      mkdir -p $out
      cp wallpaper.jpg $out/wallpaper.jpg
    '';
  };

  black="#4B5262";
  red="#BF616A";
  green="#A3BE8C";
  orange="#EBCB8B";
  blue="#81A1C1";
  magenta="#B48EAD";
  cyan="#89D0BA";
  white="#E5E9F0";

  brightBlack="#434A5A";
  brightRed="#B3555E";
  brightGreen="#93AE7C";
  brightOrange="#DBBB7B";
  brightBlue="#7191B1";
  brightMagenta="#A6809F";
  brightCyan="#7DBBA8";
  brightWhite="#D1D5DC";

  background="#2F343F";
  foreground="#D8DEE8";

  palette = "${black}:${red}:${green}:${orange}:${blue}:${magenta}:${cyan}:${white}:${brightBlack}:${brightRed}:${brightGreen}:${brightOrange}:${brightBlue}:${brightMagenta}:${brightCyan}:${brightWhite}";
in

{
  dconf.settings = {
    "org/mate/marco/general" = {
      theme = "Arc-Darker";
      mouse-button-modifier = "<Super>";
      button-layout = ":minimize,maximize,close";
    };

    "org/mate/desktop/interface" = {
      icon-theme = "ePapirus";
      gtk-theme = "Arc-Darker";
    };

    "org/mate/desktop/background" = {
      show-desktop-icons = false;
      picture-options = "scaled";
      picture-filename = "${wallpaper}/wallpaper.jpg";
    };

    "org/mate/terminal/global" = {
      ctrl-tab-switch-tabs = true;
    };

    "org/mate/terminal/profiles/default" = {
      use-theme-colors = false;
      background-color = background;
      foreground-color = foreground;
      palette = palette;
      allow-bold = true;
      default-show-menubar = false;
      default-size-columns = 120;
      default-size-rows = 35;
      use-custom-default-size = true;
      use-system-font = true;
      scrollback-unlimited = true;
      scrollbar-position = "hidden";
    };

    "org/mate/desktop/sound" = {
      input-feedback-sounds = false;
      theme-name = "__no_sounds";
      event-sounds = false;
    };
  };
}

