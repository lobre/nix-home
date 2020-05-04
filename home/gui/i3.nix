{ config, pkgs, ... }:

let
  modifier = "Mod4";
  theme = config.theme;
  lockFont = builtins.replaceStrings [" "] ["-"] "${theme.font.fullname}";
  lockScript = pkgs.writeScriptBin "i3lock-no-notif" ''
    #!${pkgs.stdenv.shell}
    notify-send "DUNST_COMMAND_PAUSE"
    ${pkgs.i3lock-fancy}/bin/i3lock-fancy "$@"
    notify-send "DUNST_COMMAND_RESUME"
  '';
in

{
  xsession.windowManager.i3 = {
    enable = true;
    package = pkgs.i3-gaps;

    config = {
      modifier = "${modifier}";
      workspaceLayout = "default";
      fonts = [ "${theme.font.nerd-family} 12" ];

      keybindings = {
        # switching between workspace
        "${modifier}+p" = "workspace prev_on_output";
        "${modifier}+n" = "workspace next_on_output";
        "mod1+shift+Tab" = "workspace prev_on_output";
        "mod1+Tab" = "workspace next_on_output";

        # change focus
        "${modifier}+h" = "focus left";
        "${modifier}+j" = "focus down";
        "${modifier}+k" = "focus up";
        "${modifier}+l" = "focus right";

        # kill focused window
        "${modifier}+q" = "kill";
        "--release button2" = "kill";
        "--whole-window ${modifier}+button2" = "kill";

        # enter fullscreen mode for the focused container
        "${modifier}+z" = "fullscreen";

        # change container layout (stacked, tabbed, toggle split)
        "${modifier}+equal" = "layout stacking";
        "${modifier}+asterisk" = "layout tabbed";
        "${modifier}+plus" = "layout toggle split";

        # split in honizontal/vertical orientation
        "${modifier}+slash" = "split h";
        "${modifier}+minus" = "split v";

        # Toggle between stacking/tabbed/split:
        "${modifier}+x" = "layout toggle";

        # toggle tiling / floating
        "${modifier}+f" = "floating toggle";

        # Change focus between tiling / floating windows
        "${modifier}+Shift+f" = "focus mode_toggle";

        # focus the parent/child container
        "${modifier}+a" = "focus parent";
        "${modifier}+u" = "focus child";

        # Sound shortcuts
        "XF86AudioRaiseVolume" = "exec --no-startup-id pactl set-sink-volume @DEFAULT_SINK@ +10%";
        "XF86AudioLowerVolume" = "exec --no-startup-id pactl set-sink-volume @DEFAULT_SINK@ -10%";
        "XF86AudioMute" = "exec --no-startup-id pactl set-sink-mute @DEFAULT_SINK@ toggle";

        # Sreen brightness controls
        "XF86MonBrightnessUp" = "exec xbacklight -inc 20 # increase screen brightness";
        "XF86MonBrightnessDown" = "exec xbacklight -dec 20 # decrease screen brightness";

        # Scratchpad
        "${modifier}+Shift+dollar" = "move scratchpad";
        "${modifier}+dollar" = "scratchpad show";

        # Rofi
        "${modifier}+space" = "exec --no-startup-id rofi -show drun";
        "${modifier}+w" = "exec --no-startup-id rofi -show window";
        "${modifier}+v" = "exec --no-startup-id rofi -modi 'clipboard:greenclip print' -show clipboard";
        "${modifier}+m" = "exec --no-startup-id rofi -modi 'monitors:rofi-arandr-monitors.sh' -show monitors";
        "${modifier}+c" = "exec --no-startup-id rofi -modi 'layouts:rofi-setxkbmap.sh' -show layouts";
        "${modifier}+shift+d" = "exec --no-startup-id rofi -modi 'dunst:rofi-dunst-mute.sh' -show dunst";

        # Reload setxkbmap service
        "${modifier}+shift+m" = "exec --no-startup-id systemctl --user restart setxkbmap.service";

        # Reload background service
        "${modifier}+b" = "exec --no-startup-id systemctl --user restart random-background.service";

        # Start a terminal
        "${modifier}+Return" = "exec --no-startup-id alacritty --working-directory \"`${pkgs.xcwd}/bin/xcwd`\"";

        # Screenshot
        "Print" = "exec --no-startup-id shutter --select --disable_systray";

        # Gnome settings
        "${modifier}+F1" = "exec --no-startup-id env XDG_CURRENT_DESKTOP=GNOME gnome-control-center";

        # Enable modes
        "${modifier}+r" = "mode resize";
        "${modifier}+Delete" = "mode power";
        "${modifier}+t" = "mode ws";
        "${modifier}+s" = "mode switch";
        "${modifier}+o" = "mode output";
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
        # Remove screensaver and turn off screen after 5 min
        { command = "xset +dpms"; notification = false; }
        { command = "xset dpms 0 0 300"; notification = false; }
        { command = "xset s off"; notification = false; }

        # Autolock after 10 min except if mouse in bottom right corner
        { command = "xautolock -corners 000- -detectsleep -time 10 -locker \"${lockScript}/bin/i3lock-no-notif -n --text 'Enter Laboratory' --font '${lockFont}' --greyscale\""; notification = false; }

        # Make keyboard stop faster
        { command = "sleep 2 && xset r rate 200 25"; notification = false; }

        # Start applets
        { command = "nm-applet"; notification = false; }

        # Clipboard manager
        { command = "greenclip daemon"; notification = false; }

        # Select first workspace
        { command = "i3-msg workspace 1:T"; notification = false; }

        # Enable vmware guests if installed
        { command = "vmware-user"; notification = false; }
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
        followMouse = true;
        forceWrapping = false;
        mouseWarping = false;
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

        power = {
          l = "mode default, exec --no-startup-id ${lockScript}/bin/i3lock-no-notif -n --text 'Enter Laboratory' --font '${lockFont}' --greyscale";
          e = "mode default, exec --no-startup-id i3-msg exit";
          r = "mode default, exec --no-startup-id systemctl reboot";
          p = "mode default, exec --no-startup-id systemctl poweroff -i";
          c = "mode default, restart";

          Return = "mode default";
          Escape = "mode default";
        };

        ws = {
          t = "mode default, workspace 1:T";
          s = "mode default, workspace 2:S";
          r = "mode default, workspace 3:R";
          n = "mode default, workspace 4:N";
          v = "mode default, workspace 5:V";
          d = "mode default, workspace 6:D";
          l = "mode default, workspace 7:L";
          j = "mode default, workspace 8:J";

          Return = "mode default";
          Escape = "mode default";
        };

        switch = {
          h = "move left";
          j = "move down";
          k = "move up";
          l = "move right";

          "shift+t" = "mode default, move container to workspace 1:T";
          "shift+s" = "mode default, move container to workspace 2:S";
          "shift+r" = "mode default, move container to workspace 3:R";
          "shift+n" = "mode default, move container to workspace 4:N";
          "shift+v" = "mode default, move container to workspace 5:V";
          "shift+d" = "mode default, move container to workspace 6:D";
          "shift+l" = "mode default, move container to workspace 7:L";
          "shift+j" = "mode default, move container to workspace 8:J";

          Return = "mode default";
          Escape = "mode default";
        };

        output = {
          h = "mode default, move workspace to output left";
          j = "mode default, move workspace to output down";
          k = "mode default, move workspace to output up";
          l = "mode default, move workspace to output right";

          Return = "mode default";
          Escape = "mode default";
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
          workspaceNumbers = false;
          command = "i3bar";
          fonts = [ "${theme.font.nerd-family} 12" ];
          hiddenState = "hide";

          colors = {
            background = "${theme.colors.background}";
            statusline = "${theme.colors.background}";
            separator = "${theme.colors.background}";

            focusedWorkspace  = { border = "${theme.colors.color4}";     background = "${theme.colors.color4}";     text = "${theme.colors.background}"; };
            activeWorkspace   = { border = "${theme.colors.darkAlt}";     background = "${theme.colors.darkAlt}";     text = "${theme.colors.foreground}"; };
            inactiveWorkspace = { border = "${theme.colors.background}"; background = "${theme.colors.background}"; text = "${theme.colors.foreground}"; };
            urgentWorkspace   = { border = "${theme.colors.urgent}";     background = "${theme.colors.urgent}";     text = "${theme.colors.background}"; };
            bindingMode       = { border = "${theme.colors.color5}";     background = "${theme.colors.color5}";     text = "${theme.colors.background}"; };
          };
        }
      ];
    };
  };
}
