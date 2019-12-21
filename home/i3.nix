{ config, pkgs, ... }:

{
  xsession.windowManager.i3 = {
  enable = true;
  package = pkgs.i3-gaps;
  
  config = {
    modifier = "${modifier}";
    workspaceLayout = "default";
    fonts = [ "monospace 8" ];
  
    keybindings = {
      # custom switch to workspace
      "${modifier}+mod1+t" = "workspace T";
      "${modifier}+mod1+s" = "workspace S";
      "${modifier}+mod1+r" = "workspace R";
      "${modifier}+mod1+n" = "workspace N";
      "${modifier}+mod1+v" = "workspace V";
      "${modifier}+mod1+d" = "workspace D";
      "${modifier}+mod1+l" = "workspace L";
      "${modifier}+mod1+j" = "workspace J";
  
      # switching between workspace
      "${modifier}+p" = "workspace prev_on_output";
      "${modifier}+n" = "workspace next_on_output";
      "mod1+Shift+Tab" = "workspace prev_on_output";
      "mod1+Tab" = "workspace next_on_output";
  
      # custom move focused container to workspace
      "${modifier}+mod1+Shift+t" = "move container to workspace T";
      "${modifier}+mod1+Shift+s" = "move container to workspace S";
      "${modifier}+mod1+Shift+r" = "move container to workspace R";
      "${modifier}+mod1+Shift+n" = "move container to workspace N";
      "${modifier}+mod1+Shift+v" = "move container to workspace V";
      "${modifier}+mod1+Shift+d" = "move container to workspace D";
      "${modifier}+mod1+Shift+l" = "move container to workspace L";
      "${modifier}+mod1+Shift+j" = "move container to workspace J";
  
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
      "${modifier}+space" = "exec dmenu_run";
  
      # Start a terminal
      "${modifier}+Return" = "exec urxvt -cd \"`${pkgs.xcwd}`\"";
      "${modifier}+Shift+Return" = "exec urxvt -name floating -cd \"`${pkgs.xcwd}`\"";
  
      # Enable modes
      "${modifier}+mod1+c" = "mode reload";
      "${modifier}+mod1+h" = "mode resize";
    };
  
    colors = {
      background = "#ffffff";
      focused = { background = "#285577"; border = "#4c7899"; childBorder = "#285577"; indicator = "#2e9ef4"; text = "#ffffff"; };
      focusedInactive = { background = "#5f676a"; border = "#333333"; childBorder = "#5f676a"; indicator = "#484e50"; text = "#ffffff"; };
      placeholder = { background = "#0c0c0c"; border = "#000000"; childBorder = "#0c0c0c"; indicator = "#000000"; text = "#ffffff"; };
      unfocused = { background = "#222222"; border = "#333333"; childBorder = "#222222"; indicator = "#292d2e"; text = "#888888"; };
      urgent = { background = "#900000"; border = "#2f343a"; childBorder = "#900000"; indicator = "#900000"; text = "#ffffff"; };
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
  
      { command = "compton -b"; notification = false; always = true; }
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
  
      reload = {
        c = "mode default, reload";
        r = "mode default, restart";
  
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
        position = "bottom";
        trayOutput = "primary";
        workspaceButtons = true;
        workspaceNumbers = true;
        command = "i3bar";
        fonts = [ "monospace 8" ];
        hiddenState = "hide";
  
        colors = {
          background = "#000000";
          activeWorkspace = { background = "#5f676a"; border = "#333333"; text = "#ffffff"; };
          inactiveWorkspace = { background = "#222222"; border = "#333333"; text = "#888888"; };
          focusedWorkspace = { background = "#285577"; border = "#4c7899"; text = "#ffffff"; };
          urgentWorkspace = { background = "#900000"; border = "#2f343a"; text = "#ffffff"; };
          bindingMode = { background = "#900000"; border = "#2f343a"; text = "#ffffff"; }; 
          separator = "#666666";
          statusline = "#ffffff";
        };
      }
    ];
  
  };
  
  extraConfig = ''
  '';

  };

}
