{ config, pkgs, ... }:

let
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

  background="#363636";
  foreground="#D8DEE8";

  palette = "${black}:${red}:${green}:${orange}:${blue}:${magenta}:${cyan}:${white}:${brightBlack}:${brightRed}:${brightGreen}:${brightOrange}:${brightBlue}:${brightMagenta}:${brightCyan}:${brightWhite}";
in

{
  dconf.settings = {
    "io/elementary/terminal/settings" = {
      tab-bar-behavior = "Hide When Single Tab";
      unsafe-paste-alert = false;
      follow-last-tab = true;
      prefer-dark-style = true;

      background = background;
      foreground = foreground;
      palette = palette;
    };

    "io/elementary/desktop/wingpanel" = {
      use-transparency = true;
    };

    "org/gnome/settings-daemon/plugins/media-keys" = {
      www = "";
      screensaver = "";
      terminal = "";

      area-screenshot = "";
      area-screenshot-clip = "<Super>g";
      screenshot = "";
      screenshot-clip = "";
      window-screenshot = "";
      window-screenshot-clip = "";

      custom-keybindings = [
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/"
      ];
    };

    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
      binding = "<Super>Return";
      command = "io.elementary.terminal --new-window";
      name = "io.elementary.terminal --new-window";
    };

    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1" = {
      binding = "<Super>v";
      command = "copyq show";
      name = "copyq show";
    };

    "org/gnome/desktop/interface" = {
      font-name = "Roboto 9";
      document-font-name = "Roboto 10";
      text-scaling-factor = 1.0;
    };

    "org/gnome/desktop/wm/preferences" = {
      titlebar-font = "Roboto Bold 9";
    };

    "org/gnome/desktop/wm/keybindings" = {
      switch-to-workspace-right = [ "<Super>l" "<Super>Right" ];
      switch-to-workspace-left = [ "<Super>h" "<Super>Left" ];
      move-to-workspace-left = [ "<Alt><Super>Left" "<Alt><Super>h" ];
      move-to-workspace-right = [ "<Alt><Super>Right" "<Alt><Super>l" ];
      move-to-monitor-up = [ "<Shift><Super>k" "<Shift><Super>Up" ];
      move-to-monitor-down = [ "<Shift><Super>j" "<Shift><Super>Down" ];
      move-to-monitor-right = [ "<Shift><Super>l" "<Shift><Super>Right" ];
      move-to-monitor-left = [ "<Shift><Super>h" "<Shift><Super>Left" ];
      show-desktop = [ "<Super>w" "<Super>Down" ];
      minimize = [ "<Super>j" ];
      close = [ "<Alt>F4" "<Super>q" ];
      toggle-maximized = [ "<Super>Up" "<Super>z" ];
      switch-to-workspace-1 = [ "<Super>7" ];
      switch-to-workspace-2 = [ "<Super>8" ];
      switch-to-workspace-3 = [ "<Super>9" ];
      switch-to-workspace-4 = [ "<Super>0" ];
      switch-to-workspace-5 = [ "" ];
      switch-to-workspace-6 = [ "" ];
      switch-to-workspace-7 = [ "" ];
      switch-to-workspace-8 = [ "" ];
      switch-to-workspace-9 = [ "" ];
      move-to-workspace-1 = [ "<Shift><Super>7" ];
      move-to-workspace-2 = [ "<Shift><Super>8" ];
      move-to-workspace-3 = [ "<Shift><Super>9" ];
      move-to-workspace-4 = [ "<Shift><Super>0" ];
      move-to-workspace-5 = [ "" ];
      move-to-workspace-6 = [ "" ];
      move-to-workspace-7 = [ "" ];
      move-to-workspace-8 = [ "" ];
      move-to-workspace-9 = [ "" ];
    };

    "org/gnome/mutter/keybindings" = {
      toggle-tiled-right = [ "<Primary><Super>l" "<Primary><Super>Right" ];
      toggle-tiled-left = [ "<Primary><Super>h" "<Primary><Super>Left" ];
    };
  };
}

