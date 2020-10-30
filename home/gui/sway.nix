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
      workspaceLayout = "default";
      fonts = [ "${theme.font.nerd-family} 12" ];

      terminal = "${config.programs.alacritty.package}/bin/alacritty";

      keybindings = {
        "mod1+Shift+Tab" = "workspace prev_on_output";
        "mod1+Tab" = "workspace next_on_output";
        "${mod}+p" = "workspace prev_on_output";
        "${mod}+n" = "workspace next_on_output";

        "${mod}+Return" = "exec ${config.programs.alacritty.package}/bin/alacritty";
        "${mod}+Shift+q" = "kill";
        "${mod}+space" = "exec ${pkgs.dmenu}/bin/dmenu_path | ${pkgs.dmenu}/bin/dmenu | ${pkgs.findutils}/bin/xargs swaymsg exec --";

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

        "${mod}+z" = "fullscreen toggle";
        "${mod}+a" = "focus parent";

        "${mod}+s" = "layout stacking";
        "${mod}+w" = "layout tabbed";
        "${mod}+e" = "layout toggle split";

        "${mod}+f" = "floating toggle";
        "${mod}+Shift+f" = "focus mode_toggle";

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
        "${mod}+o" = "mode output";
        "${mod}+Delete" = "mode power";
      };

      # Colors for windows.
      #
      # border, background and text: will be visible in the titlebar for tabbed or stacked modes.
      # indicator: will be visible in split mode and will show where the next window will open.
      # childBorder: is the actual window border around the child window.
      # background: is used to paint the background of the client window. Only clients which do not cover
      # the whole area of this window expose the color.
      colors = {
        focused         = { border = "${theme.colors.color4}";     background = "${theme.colors.color4}";     text = "${theme.colors.background}"; indicator = "${theme.colors.foreground}"; childBorder = "${theme.colors.color4}"; };
        focusedInactive = { border = "${theme.colors.background}"; background = "${theme.colors.background}"; text = "${theme.colors.foreground}"; indicator = "${theme.colors.background}"; childBorder = "${theme.colors.background}"; };
        unfocused       = { border = "${theme.colors.background}"; background = "${theme.colors.background}"; text = "${theme.colors.foreground}"; indicator = "${theme.colors.background}"; childBorder = "${theme.colors.background}"; };
        urgent          = { border = "${theme.colors.urgent}";     background = "${theme.colors.urgent}";     text = "${theme.colors.background}"; indicator = "${theme.colors.background}"; childBorder = "${theme.colors.urgent}"; };
        placeholder     = { border = "${theme.colors.background}"; background = "${theme.colors.background}"; text = "${theme.colors.foreground}"; indicator = "${theme.colors.background}"; childBorder = "${theme.colors.background}"; };
        background      = "${theme.colors.background}";
      };

      startup = [
        # Enable vmware guests if installed
        { command = "vmware-user"; }
      ];

      floating = {
        border = 3;

        criteria = [ 
          { title = "Microsoft Teams Notification"; }
        ];
      };

      window = {
        hideEdgeBorders = "smart";
        border = 3;
        titlebar = false;
      };

      focus = {
        # does focus follows mouse
        followMouse = true;
        # does mouse reset to focused container
        mouseWarping = true;
        # disable cycle focus back to opposite window in containers when reaching the edge
        forceWrapping = false;
        newWindow = "smart";
      };

      modes = { 
        resize = { 
          h = "resize grow width 5 px or 5 ppt";
          j = "resize grow height 5 px or 5 ppt";
          k = "resize shrink height 5 px or 5 ppt";
          l = "resize shrink width 5 px or 5 ppt";

          Return = "mode default";
          Escape = "mode default";
        }; 

        output = {
          h = "move workspace to output left";
          j = "move workspace to output down";
          k = "move workspace to output up";
          l = "move workspace to output right";

          Return = "mode default";
          Escape = "mode default";
        };

        power = {
          e = "mode default, exec swaynag -t warning -m 'You pressed the exit shortcut. Do you really want to exit sway? This will end your Wayland session.' -b 'Yes, exit sway' 'swaymsg exit'";
          r = "mode default, exec --no-startup-id systemctl reboot";
          p = "mode default, exec --no-startup-id systemctl poweroff -i";
          c = "mode default, restart";

          Return = "mode default";
          Escape = "mode default";
        };
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
          mode = "dock";
          position = "top";
          trayOutput = "primary";
          workspaceButtons = true;
          workspaceNumbers = true;
          fonts = [ "${theme.font.nerd-family} 12" ];
          hiddenState = "hide";

          colors = {
            background = "${theme.colors.background}";
            statusline = "${theme.colors.background}";
            separator = "${theme.colors.background}";

            focusedWorkspace  = { border = "${theme.colors.color4}";     background = "${theme.colors.color4}";     text = "${theme.colors.background}"; };
            activeWorkspace   = { border = "${theme.colors.darkAlt}";    background = "${theme.colors.darkAlt}";     text = "${theme.colors.foreground}"; };
            inactiveWorkspace = { border = "${theme.colors.background}"; background = "${theme.colors.background}"; text = "${theme.colors.foreground}"; };
            urgentWorkspace   = { border = "${theme.colors.urgent}";     background = "${theme.colors.urgent}";     text = "${theme.colors.background}"; };
            bindingMode       = { border = "${theme.colors.color5}";     background = "${theme.colors.color5}";     text = "${theme.colors.background}"; };
          };
        }
      ];
    };

    extraSessionCommands = ''
      export SDL_VIDEODRIVER=wayland
      export QT_QPA_PLATFORM=wayland
      export QT_WAYLAND_DISABLE_WINDOWDECORATION="1"
      export _JAVA_AWT_WM_NONREPARENTING=1
    '';
  };

  home.packages = with pkgs; [
    dmenu
    swayidle
    swaylock
    wev
  ];
}
