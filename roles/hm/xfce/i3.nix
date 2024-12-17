{ pkgs, ... }:

let
  i3-breadcrumb = pkgs.writeScriptBin "i3-breadcrumb" ''
    #!${pkgs.stdenv.shell}

    ${pkgs.i3}/bin/i3-msg -t get_tree | jq -r '
    def filter_focused:
      if .focused == true then {type, layout, workspace_layout, window, focused}
      elif .nodes then
        {type, layout, workspace_layout, window, focused, nodes: (.nodes | map(filter_focused) | select(length > 0))}
      else empty
      end;

    [.. | objects | select(.type == "workspace") | filter_focused | .. | objects |
      if .type == "workspace" then
        "W[" + .layout + "/" + .workspace_layout + "]"
      elif .window != null then
        "WIN"
      else
        "C[" + .layout + "]"
      end
    ] | reverse | join(" 🞉 ")'
  '';

  i3-status = pkgs.writeScriptBin "i3-status" ''
    #!${pkgs.stdenv.shell}

    while true; do
      printf "%s | %s\n" "$(${i3-breadcrumb}/bin/i3-breadcrumb)" "$(date +'%H:%M, %a %d %B %Y')"
      sleep 0.5
    done
  '';
in

{
  xdg.configFile."i3/config".text = ''
    # variables
    set $alt Mod1
    set $altgr Group2
    set $super Mod4

    # Use mouse and super to drag floating windows
    floating_modifier $super

    font pango:Iosevka Term Regular 9

    # borders
    default_border pixel 2
    default_floating_border normal
    hide_edge_borders smart

    # kill window
    bindsym $super+x kill
    bindsym --release button2 kill
    bindsym --whole-window $super+button2 kill

    # change focus
    bindsym $super+Left focus left
    bindsym $super+Down focus down
    bindsym $super+Up focus up
    bindsym $super+Right focus right

    # move focused window
    bindsym $super+Shift+Left move left
    bindsym $super+Shift+Down move down
    bindsym $super+Shift+Up move up
    bindsym $super+Shift+Right move right

    # enter fullscreen
    bindsym $super+z fullscreen toggle

    # toogle and swap between floating and tiling
    bindsym $super+Shift+t floating toggle
    bindsym $super+t focus mode_toggle

    # focus the parent container
    bindsym $super+a focus parent
    bindsym $super+Shift+a focus child

    # default workspace layout
    workspace_layout tabbed

    # split vertically
    bindsym $super+s splith
    bindsym $super+Shift+s splitv

    # switch container between styles
    bindsym $super+d layout toggle tabbed stacking splitv splith
    bindsym $super+f layout toggle splith splitv stacking tabbed

    # scratchpad
    bindsym $super+$altgr+Shift+minus move scratchpad
    bindsym $super+$altgr+minus scratchpad show

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

    # last workspace back and forth
    bindsym $super+Tab workspace back_and_forth

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
        status_command exec ${i3-status}/bin/i3-status
        tray_output primary
        font pango:Iosevka Term Regular 9
    }

    # set applauncher floating
    for_window [class="Xfce4-appfinder"] floating enable

    # compositor to avoid graphical glitches and allow transparency
    exec --no-startup-id "${pkgs.picom}/bin/picom --fading --fade-in-step=1.0 --fade-out-step=1.0"

    # sound applet
    exec --no-startup-id "${pkgs.pasystray}/bin/pasystray"
  '';
}
