{ pkgs, ... }:

{
  xdg.configFile."i3/config".text = ''
    # variables
    set $alt Mod1
    set $super Mod4

    # Use mouse and super to drag floating windows
    floating_modifier $super

    font pango:monospace 8

    # borders
    default_border pixel 2
    default_floating_border normal
    hide_edge_borders smart

    # kill window
    bindsym $super+Shift+q kill
    bindsym --release button2 kill
    bindsym --whole-window $super+button2 kill

    # change focus
    bindsym $super+h focus left
    bindsym $super+j focus down
    bindsym $super+k focus up
    bindsym $super+l focus right

    bindsym $super+Left focus left
    bindsym $super+Down focus down
    bindsym $super+Up focus up
    bindsym $super+Right focus right

    # move focused window
    bindsym $super+Shift+h move left
    bindsym $super+Shift+j move down
    bindsym $super+Shift+k move up
    bindsym $super+Shift+l move right

    bindsym $super+Shift+Left move left
    bindsym $super+Shift+Down move down
    bindsym $super+Shift+Up move up
    bindsym $super+Shift+Right move right

    # enter fullscreen
    bindsym $super+f fullscreen toggle

    # toogle and swap between floating and tiling
    bindsym $super+Shift+t floating toggle
    bindsym $super+t focus mode_toggle

    # focus the parent container
    bindsym $super+a focus parent

    # split horizontally or vertically
    bindsym $super+b splith
    bindsym $super+v splitv

    # switch container between styles
    bindsym $super+s layout stacking
    bindsym $super+w layout tabbed
    bindsym $super+e layout toggle split

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

        bindsym Left move workspace to output left
        bindsym Down move workspace to output down
        bindsym Up move workspace to output up
        bindsym Right move workspace to output right

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

        bindsym Left resize shrink width 10 px or 10 ppt
        bindsym Down resize grow height 10 px or 10 ppt
        bindsym Up resize shrink height 10 px or 10 ppt
        bindsym Right resize grow width 10 px or 10 ppt

        bindsym Return mode "default"
        bindsym Escape mode "default"
    }

    bindsym $super+r mode "resize"

    # reload the configuration file
    bindsym $super+Shift+c reload

    bar {
        i3bar_command ${pkgs.i3}/bin/i3bar
        status_command while true; do echo $(date +'%H:%M, %a %d %B %Y'); sleep 1; done
        tray_output primary
    }

    # set applauncher floating
    for_window [class="Xfce4-appfinder"] floating enable

    # compositor to avoid graphical glitches and allow transparency
    exec --no-startup-id "${pkgs.picom}/bin/picom --fading --fade-in-step=1.0 --fade-out-step=1.0"

    # sound applet
    exec --no-startup-id "${pkgs.pasystray}/bin/pasystray"
  '';
}
