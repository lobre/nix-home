{ config, pkgs, ... }:

let
  modifier = "Mod4";
in
{
  xsession.windowManager.i3 = {
    enable = true;
    package = pkgs.i3-gaps;
    
    config = {
      modifier = "${modifier}";
      workspaceLayout = "default";
      fonts = [ "M+ 1mn 12" ];
    
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
        "mod1+Shift+Tab" = "workspace prev_on_output";
        "mod1+Tab" = "workspace next_on_output";
    
        # custom move focused container to workspace
        "${modifier}+mod1+Shift+t" = "move container to workspace 1:T";
        "${modifier}+mod1+Shift+s" = "move container to workspace 2:S";
        "${modifier}+mod1+Shift+r" = "move container to workspace 3:R";
        "${modifier}+mod1+Shift+n" = "move container to workspace 4:N";
        "${modifier}+mod1+Shift+v" = "move container to workspace 5:V";
        "${modifier}+mod1+Shift+d" = "move container to workspace 6:D";
        "${modifier}+mod1+Shift+l" = "move container to workspace 7:L";
        "${modifier}+mod1+Shift+j" = "move container to workspace 8:J";
    
        # move focused container to next/previous workspace
        "${modifier}+Shift+n" = "move container to workspace next";
        "${modifier}+Shift+p" = "move container to workspace prev";
    
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
        "${modifier}+Shift+c" = "move left";
        "${modifier}+Shift+t" = "move down";
        "${modifier}+Shift+s" = "move up";
        "${modifier}+Shift+r" = "move right";
    
        # kill focused window
        "${modifier}+q" = "kill";
    
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
    
        # Program launcher
        "${modifier}+space" = "exec rofi -show drun";
    
        # Start a terminal
        "${modifier}+Return" = "exec urxvt -cd \"`${pkgs.xcwd}/bin/xcwd`\"";
        "${modifier}+Shift+Return" = "exec urxvt -name floating -cd \"`${pkgs.xcwd}`\"";
    
        # Enable modes
        "${modifier}+h" = "mode resize";
        "${modifier}+Delete" = "mode power";
      };
    
      colors = {
        focused = { border = "#bf616a"; background = "#2f343f"; text = "#d8dee8"; indicator = "#bf616a"; childBorder = "#d8dee8"; };
        focusedInactive = { border = "#2f343f"; background = "#2f343f"; text = "#d8dee8"; indicator = "#2f343f"; childBorder = "#2f343f"; };
        unfocused = { border = "#2f343f"; background = "#2f343f"; text = "#d8dee8"; indicator = "#2f343f"; childBorder = "#2f343f"; };
        urgent = { border = "#2f343f"; background = "#2f343f"; text = "#d8dee8"; indicator = "#2f343f"; childBorder = "#2f343f"; };
        placeholder = { border = "#2f343f"; background = "#2f343f"; text = "#d8dee8"; indicator = "#2f343f"; childBorder = "#2f343f"; };
        background = "#2f343f";
      };
    
      startup = [
        # Remove screensaver and turn off screen after 5 min
        { command = "xset +dpms"; notification = false; }
        { command = "xset dpms 0 0 300"; notification = false; }
        { command = "xset s off"; notification = false; }
    
        # Change mouse speed
        { command = "xset m 5 1"; notification = false; }
    
        # Make keyboard stop faster
        { command = "sleep 2 && xset r rate 200 25"; notification = false; }
    
        { command = "nm-applet"; notification = false; }
      ];
    
      window = {
        border = 3;
        hideEdgeBorders = "smart";
      };
    
      floating = {
        border = 3;
    
        criteria = [
          { class = "URxvt"; instance = "floating"; }
        ];
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
          l = "mode default, exec --no-startup-id ${pkgs.i3lock-fancy}/bin/i3lock-fancy --text 'Enter Laboratory' --font 'M+-1mn' --greyscale";
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
          fonts = [ "M+ 1mn 12" ];
          hiddenState = "hide";
    
          colors = {
            background = "#2f343f";
            statusline = "#2f343f";
            separator = "#4b5262";

            focusedWorkspace = { border = "#2f343f"; background = "#bf616a"; text = "#d8dee8"; };
            activeWorkspace = { border = "#2f343f"; background = "#2f343f"; text = "#d8dee8"; };
            inactiveWorkspace = { border = "#2f343f"; background = "#2f343f"; text = "#d8dee8"; };
            urgentWorkspace = { border = "#2f343f"; background = "#ebcb8b"; text = "#2f343f"; };
            bindingMode = { border = "#2f343f"; background = "#b48ead"; text = "#2f343f"; };
          };
        }
      ];
    };
  };
}
