{ config, pkgs, ... }:

let
  theme = config.theme;
  mod = "Mod4";
in

{
  wayland.windowManager.sway = {
    enable = true;

    config = {
      modifier = "${mod}";

      terminal = "${config.programs.alacritty.package}/bin/alacritty";

      keybindings = {
        "mod1+Shift+Tab" = "workspace prev_on_output";
        "mod1+Tab" = "workspace next_on_output";
        "${mod}+p" = "workspace prev_on_output";
        "${mod}+n" = "workspace next_on_output";

        "${mod}+Return" = "exec ${config.programs.alacritty.package}/bin/alacritty";
        "${mod}+Shift+q" = "kill";
        "${mod}+d" = "exec ${pkgs.dmenu}/bin/dmenu_path | ${pkgs.dmenu}/bin/dmenu | ${pkgs.findutils}/bin/xargs swaymsg exec --";

        "${mod}+h" = "focus left";
        "${mod}+j" = "focus down";
        "${mod}+k" = "focus up";
        "${mod}+l" = "focus right";

        "${mod}+Left" = "focus left";
        "${mod}+Down" = "focus down";
        "${mod}+Up" = "focus up";
        "${mod}+Right" = "focus right";

        "${mod}+Shift+h" = "move left";
        "${mod}+Shift+j" = "move down";
        "${mod}+Shift+k" = "move up";
        "${mod}+Shift+l" = "move right";

        "${mod}+Shift+Left" = "move left";
        "${mod}+Shift+Down" = "move down";
        "${mod}+Shift+Up" = "move up";
        "${mod}+Shift+Right" = "move right";

        "${mod}+Shift+v" = "split h";
        "${mod}+Shift+s" = "split v";

        "${mod}+f" = "fullscreen toggle";
        "${mod}+a" = "focus parent";

        "${mod}+s" = "layout stacking";
        "${mod}+w" = "layout tabbed";
        "${mod}+e" = "layout toggle split";

        "${mod}+Shift+space" = "floating toggle";
        "${mod}+space" = "focus mode_toggle";

        "${mod}+quotedbl"       = "workspace number 1";
        "${mod}+guillemotleft"  = "workspace number 2";
        "${mod}+guillemotright" = "workspace number 3";
        "${mod}+parenleft"      = "workspace number 4";
        "${mod}+parenright"     = "workspace number 5";
        "${mod}+at"             = "workspace number 6";
        "${mod}+plus"           = "workspace number 7";
        "${mod}+minus"          = "workspace number 8";
        "${mod}+slash"          = "workspace number 9";
        "${mod}+asterisk"       = "workspace number 10";

        "${mod}+Shift+quotedbl"       = "move container to workspace number 1";
        "${mod}+Shift+guillemotleft"  = "move container to workspace number 2";
        "${mod}+Shift+guillemotright" = "move container to workspace number 3";
        "${mod}+Shift+parenleft"      = "move container to workspace number 4";
        "${mod}+Shift+parenright"     = "move container to workspace number 5";
        "${mod}+Shift+at"             = "move container to workspace number 6";
        "${mod}+Shift+plus"           = "move container to workspace number 7";
        "${mod}+Shift+minus"          = "move container to workspace number 8";
        "${mod}+Shift+slash"          = "move container to workspace number 9";
        "${mod}+Shift+asterisk"       = "move container to workspace number 10";

        "${mod}+Shift+dollar" = "move scratchpad";
        "${mod}+dollar" = "scratchpad show";

        "${mod}+Shift+c" = "reload";
        "${mod}+Shift+e" =
          "exec swaynag -t warning -m 'You pressed the exit shortcut. Do you really want to exit sway? This will end your Wayland session.' -b 'Yes, exit sway' 'swaymsg exit'";

        "${mod}+r" = "mode resize";
      };

      input = {
        "*" = { 
          xkb_layout = "fr";
          xkb_variant = "bepo";
          tap = "enabled";
        };
      };

      output = {
        "*" = {
          bg = "${theme.wallpaper} stretch";
        };
      };

      gaps = {
        outer = 8;
        inner = 8;
        smartBorders = "off";
        smartGaps = false;
      };

      bars = [
        {
          statusCommand = "while date +'%Y-%m-%d %l:%M:%S %p'; do sleep 1; done";
        }
      ];
    };
  };

  home.packages = with pkgs; [
    dmenu
    swayidle
    swaylock
    wev
  ];
}
