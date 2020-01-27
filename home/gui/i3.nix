{ config, pkgs, ... }:

let
  modifier = "Mod4";
  theme = config.theme;
  lockFont = builtins.replaceStrings [" "] ["-"] "${theme.font}";
in

{
  xsession.windowManager.i3 = {
    enable = true;
    package = pkgs.i3-gaps;

    config = {
      modifier = "${modifier}";
      workspaceLayout = "default";
      fonts = [ "${theme.font} 12" ];

      keybindings = {
        # custom switch to workspace
        "${modifier}+mod1+t" = "workspace 1:T";
        "${modifier}+mod1+s" = "workspace 2:S";
        "${modifier}+mod1+r" = "workspace 3:R";
        "${modifier}+mod1+n" = "workspace 4:N";
        "${modifier}+mod1+v" = "workspace 5:V";
        "${modifier}+mod1+d" = "workspace 6:D";
        "${modifier}+mod1+l" = "workspace 7:L";
        "${modifier}+mod1+j" = "workspace 8:J";

        # switching between workspace
        "${modifier}+p" = "workspace prev_on_output";
        "${modifier}+n" = "workspace next_on_output";
        "mod1+shift+Tab" = "workspace prev_on_output";
        "mod1+Tab" = "workspace next_on_output";

        # custom move focused container to workspace
        "${modifier}+mod1+shift+t" = "move container to workspace 1:T";
        "${modifier}+mod1+shift+s" = "move container to workspace 2:S";
        "${modifier}+mod1+shift+r" = "move container to workspace 3:R";
        "${modifier}+mod1+shift+n" = "move container to workspace 4:N";
        "${modifier}+mod1+shift+v" = "move container to workspace 5:V";
        "${modifier}+mod1+shift+d" = "move container to workspace 6:D";
        "${modifier}+mod1+shift+l" = "move container to workspace 7:L";
        "${modifier}+mod1+shift+j" = "move container to workspace 8:J";

        # move focused container to next/previous workspace
        "${modifier}+shift+n" = "move container to workspace next";
        "${modifier}+shift+p" = "move container to workspace prev";

        # move current workspace to next/previous output
        "${modifier}+control+c" = "move workspace to output left";
        "${modifier}+control+t" = "move workspace to output down";
        "${modifier}+control+s" = "move workspace to output up";
        "${modifier}+control+r" = "move workspace to output right";

        # change focus
        "${modifier}+c" = "focus left";
        "${modifier}+t" = "focus down";
        "${modifier}+s" = "focus up";
        "${modifier}+r" = "focus right";

        # move focused window
        "${modifier}+shift+c" = "move left";
        "${modifier}+shift+t" = "move down";
        "${modifier}+shift+s" = "move up";
        "${modifier}+shift+r" = "move right";

        # kill focused window
        "${modifier}+q" = "kill";
        "--release button2" = "kill";
        "--whole-window ${modifier}+button2" = "kill";

        # split in honizontal/vertical orientation
        "${modifier}+slash" = "split h";
        "${modifier}+minus" = "split v";

        # enter fullscreen mode for the focused container
        "${modifier}+z" = "fullscreen";

        # change container layout (stacked, tabbed, toggle split)
        "${modifier}+k" = "layout stacking";
        "${modifier}+w" = "layout tabbed";
        "${modifier}+e" = "layout toggle split";

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
        "${modifier}+g" = "exec --no-startup-id rofi -show window";
        "${modifier}+v" = "exec --no-startup-id rofi -modi 'clipboard:greenclip print' -show clipboard";
        "${modifier}+m" = "exec --no-startup-id rofi -modi 'monitors:rofi-arandr-monitors.sh' -show monitors";
        "${modifier}+shift+d" = "exec --no-startup-id rofi -modi 'dunst:rofi-dunst-mute.sh' -show dunst";

        # Reload setxkbmap service
        "${modifier}+shift+m" = "exec --no-startup-id systemctl --user restart setxkbmap.service";

        # Start a terminal
        "${modifier}+Return" = "exec --no-startup-id urxvt -cd \"`${pkgs.xcwd}/bin/xcwd`\"";
        "${modifier}+shift+return" = "exec --no-startup-id urxvt -name floating -cd \"`${pkgs.xcwd}`\"";

        # Screenshot
        "Print" = "exec --no-startup-id shutter --select --disable_systray";

        # Enable modes
        "${modifier}+h" = "mode resize";
        "${modifier}+Delete" = "mode power";
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
        urgent          = { border = "${theme.colors.background}"; background = "${theme.colors.background}"; text = "${theme.colors.foreground}"; indicator = "${theme.colors.background}"; childBorder = "${theme.colors.background}"; };
        placeholder     = { border = "${theme.colors.background}"; background = "${theme.colors.background}"; text = "${theme.colors.foreground}"; indicator = "${theme.colors.background}"; childBorder = "${theme.colors.background}"; };
        background      = "${theme.colors.background}";
      };

      startup = [
        # Remove screensaver and turn off screen after 5 min
        { command = "xset +dpms"; notification = false; }
        { command = "xset dpms 0 0 300"; notification = false; }
        { command = "xset s off"; notification = false; }

        # Autolock after 10 min except if mouse in bottom right corner
        { command = "xautolock -corners 000- -detectsleep -time 10 -locker \"i3lock-fancy -n --text 'Enter Laboratory' --font '${lockFont}' --greyscale\""; notification = false; }

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
          { class = "URxvt"; instance = "floating"; }
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
        mouseWarping = true;
        newWindow = "smart";
      };

      modes = { 
        resize = { 
          c = "resize grow width 5 px or 5 ppt";
          t = "resize grow height 5 px or 5 ppt";
          s = "resize shrink height 5 px or 5 ppt";
          r = "resize shrink width 5 px or 5 ppt";

          Return = "mode default";
          Escape = "mode default";
        }; 

        power = {
          l = "mode default, exec --no-startup-id i3lock-fancy --text 'Enter Laboratory' --font '${lockFont}' --greyscale";
          e = "mode default, exec --no-startup-id i3-msg exit";
          r = "mode default, exec --no-startup-id systemctl reboot";
          p = "mode default, exec --no-startup-id systemctl poweroff -i";
          c = "mode default, restart";

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
          fonts = [ "${theme.font} 12" ];
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
