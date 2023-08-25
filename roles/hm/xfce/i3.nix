{ pkgs, ... }:

{
  # TODO:
  # finish the styling of bars and colors
  xdg.configFile."i3/config".text = ''
    # variables
    set $alt Mod1
    set $super Mod4

    # Use mouse and super to drag floating windows
    floating_modifier $super

    font pango:monospace 8

    # kill window
    bindsym $super+q kill
    bindsym --release button2 kill
    bindsym --whole-window $super+button2 kill

    # change focus
    bindsym $super+h focus left
    bindsym $super+j focus down
    bindsym $super+k focus up
    bindsym $super+l focus right

    # move focused window
    bindsym $super+Shift+h move left
    bindsym $super+Shift+j move down
    bindsym $super+Shift+k move up
    bindsym $super+Shift+l move right

    # enter fullscreen
    bindsym $super+f fullscreen toggle

    # toogle floating and switch between floating and tiling
    bindsym $super+Shift+Return floating toggle
    bindsym $super+Shift+space focus mode_toggle

    # focus the parent or child container
    bindsym $super+p focus parent
    bindsym $super+c focus child

    # change orientation or grouping mode of windows
    bindsym $super+i split h
    bindsym $super+o layout toggle split
    bindsym $super+g layout toggle tabbed stacked

    # scratchpad
    bindsym $super+Tab scratchpad show
    bindsym $super+BackSpace move scratchpad

    # Define names for default workspaces for which we configure key bindings later on.
    # We use variables to avoid repeating the names in multiple places.
    set $ws1 "1"
    set $ws2 "2"
    set $ws3 "3"
    set $ws4 "4"
    set $ws5 "5"
    set $ws6 "6"
    set $ws7 "7"
    set $ws8 "8"
    set $ws9 "9"
    set $ws10 "10"

    # switch to workspace
    bindsym $super+1 workspace number $ws1
    bindsym $super+2 workspace number $ws2
    bindsym $super+3 workspace number $ws3
    bindsym $super+4 workspace number $ws4
    bindsym $super+5 workspace number $ws5
    bindsym $super+6 workspace number $ws6
    bindsym $super+7 workspace number $ws7
    bindsym $super+8 workspace number $ws8
    bindsym $super+9 workspace number $ws9
    bindsym $super+0 workspace number $ws10

    bindsym $alt+Tab workspace next_on_output
    bindsym $alt+Shift+Tab workspace prev_on_output

    # move focused container to workspace
    bindsym $super+Shift+1 move container to workspace number $ws1
    bindsym $super+Shift+2 move container to workspace number $ws2
    bindsym $super+Shift+3 move container to workspace number $ws3
    bindsym $super+Shift+4 move container to workspace number $ws4
    bindsym $super+Shift+5 move container to workspace number $ws5
    bindsym $super+Shift+6 move container to workspace number $ws6
    bindsym $super+Shift+7 move container to workspace number $ws7
    bindsym $super+Shift+8 move container to workspace number $ws8
    bindsym $super+Shift+9 move container to workspace number $ws9
    bindsym $super+Shift+0 move container to workspace number $ws10

    # move workspace to monitor
    mode "monitor" {
        bindsym h move workspace to output left
        bindsym j move workspace to output down
        bindsym k move workspace to output up
        bindsym l move workspace to output right

        bindsym Return mode "default"
        bindsym Escape mode "default"
    }

    bindsym $super+m mode "monitor"

    # resize window
    mode "resize" {
        bindsym h resize shrink width 10 px or 10 ppt
        bindsym j resize grow height 10 px or 10 ppt
        bindsym k resize shrink height 10 px or 10 ppt
        bindsym l resize grow width 10 px or 10 ppt

        bindsym Return mode "default"
        bindsym Escape mode "default"
    }

    bindsym $super+r mode "resize"

    # restart i3 or reload the configuration file
    bindsym $super+Shift+c reload
    bindsym $super+Shift+r restart

    bar {
        position bottom
        tray_output none
        i3bar_command ${pkgs.i3}/bin/i3bar --transparency

        colors {
            background #000000
            statusline #ffffff
            separator #666666

            focused_workspace  #4c7899 #285577 #ffffff
            active_workspace   #333333 #5f676a #ffffff
            inactive_workspace #333333 #222222 #888888
            urgent_workspace   #2f343a #900000 #ffffff
            binding_mode       #2f343a #900000 #ffffff
        }
    }

    # class                 border  backgr. text    indicator child_border
    client.focused          #4c7899 #285577 #ffffff #2e9ef4   #285577
    client.focused_inactive #333333 #5f676a #ffffff #484e50   #5f676a
    client.unfocused        #333333 #222222 #888888 #292d2e   #222222
    client.urgent           #2f343a #900000 #ffffff #900000   #900000
    client.placeholder      #000000 #0c0c0c #ffffff #000000   #0c0c0c

    client.background       #ffffff

    # compositor to avoid graphical glitches and allow transparency
    exec --no-startup-id "${pkgs.picom}/bin/picom --fading --fade-in-step=1.0 --fade-out-step=1.0"
  '';
}
