{ config, pkgs, ... }:

let
  colors = import ./colors.nix;
  mod = "Mod4";

  wallpaper = "$HOME/${config.xdg.dataFile."wallpaper.jpg".target}";

  # Custom script to start sway from tty.
  # It will make sure ~/.xprofile is loaded.
  startw = pkgs.writeScriptBin "startw" ''
    #!${pkgs.stdenv.shell}
    source ~/.xprofile
    ${config.wayland.windowManager.sway.package}/bin/sway
  '';

  # Allow to fallback to native swaylock if on non-nixos
  # This is proposed due to pam incompatibilities.
  # See https://gist.github.com/rossabaker/f6e5e89fd7423e1c0730fcd950c0cd33
  lockScript = pkgs.writeScriptBin "swaylock" ''
    #!${pkgs.stdenv.shell}
    PATH=$PATH:/usr/bin:/usr/local/bin:${pkgs.swaylock}/bin swaylock "$@"
  '';
in

{
  home.packages = with pkgs; [
    startw

    wdisplays
    wev
    wl-clipboard # needed for vim clipboard
    wofi
  ];

  wayland.windowManager.sway = {
    enable = true;

    config = {
      modifier = "${mod}";
      workspaceLayout = "default";
      fonts = [ "monospace 10" ];

      terminal = "${config.programs.alacritty.package}/bin/alacritty";

      keybindings = {
        "mod1+Shift+Tab" = "workspace prev_on_output";
        "mod1+Tab" = "workspace next_on_output";
        "${mod}+p" = "workspace prev_on_output";
        "${mod}+n" = "workspace next_on_output";

        "${mod}+Return" = "exec ${config.programs.alacritty.package}/bin/alacritty";
        "${mod}+space" = "exec ${pkgs.wofi}/bin/wofi";
        "${mod}+v" = "exec ${pkgs.clipman}/bin/clipman pick -t wofi";

        "${mod}+Shift+q" = "kill";
        "--release button2" = "kill";
        "--whole-window ${mod}+button2" = "kill";

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

        "${mod}+r" = "mode resize";
        "${mod}+o" = "mode output";
        "${mod}+Delete" = "mode power";

        "XF86AudioRaiseVolume" = "exec pactl set-sink-volume @DEFAULT_SINK@ +10%";
        "XF86AudioLowerVolume" = "exec pactl set-sink-volume @DEFAULT_SINK@ -10%";
        "XF86AudioMute" = "exec pactl set-sink-mute @DEFAULT_SINK@ toggle";

        # Sreen brightness controls
        # make sure your user belong to the "video" group to have permissions (sudo usermod -a -G video $USER)
        # make also sure you have the correct udev rules in place (https://github.com/haikarainen/light/blob/master/90-backlight.rules)
        "XF86MonBrightnessUp" = "exec ${pkgs.light}/bin/light -A 30 # increase screen brightness";
        "XF86MonBrightnessDown" = "exec ${pkgs.light}/bin/light -U 30 # decrease screen brightness";

        # Screenshots
        "${mod}+g" = "exec ${pkgs.grim}/bin/grim -g \"$(${pkgs.slurp}/bin/slurp -d)\" - | ${pkgs.wl-clipboard}/bin/wl-copy";
        "${mod}+Shift+g" = "exec ${pkgs.grim}/bin/grim -g \"$(${pkgs.slurp}/bin/slurp -d)\" $(xdg-user-dir PICTURES)/$(date +'%s_grim.png')";
      };

      # Colors for windows.
      #
      # border, background and text: will be visible in the titlebar for tabbed or stacked modes.
      # indicator: will be visible in split mode and will show where the next window will open.
      # childBorder: is the actual window border around the child window.
      # background: is used to paint the background of the client window. Only clients which do not cover
      # the whole area of this window expose the color.
      colors = {
        focused         = { border = "${colors.blue-800}"; background = "${colors.blue-800}"; text = "${colors.gray-100}"; indicator = "${colors.gray-100}"; childBorder = "${colors.blue-700}"; };
        focusedInactive = { border = "${colors.blue-800}"; background = "${colors.blue-800}"; text = "${colors.gray-100}"; indicator = "${colors.gray-800}"; childBorder = "${colors.gray-700}"; };
        unfocused       = { border = "${colors.gray-700}"; background = "${colors.gray-800}"; text = "${colors.gray-100}"; indicator = "${colors.gray-800}"; childBorder = "${colors.gray-700}"; };
        urgent          = { border = "${colors.red-800}";  background = "${colors.red-800}";  text = "${colors.gray-100}"; indicator = "${colors.gray-800}"; childBorder = "${colors.red-800}"; };
        placeholder     = { border = "${colors.gray-700}"; background = "${colors.gray-800}"; text = "${colors.gray-100}"; indicator = "${colors.gray-800}"; childBorder = "${colors.gray-700}"; };
        background      = "${colors.gray-800}";
      };

      startup = [
        # Enable vmware guests if installed
        { command = "vmware-user"; }

        # Pulse does not get started automatically, so using this hack
        { command = "systemctl --user restart pulseaudio.service"; }

        { command = "systemctl --user stop dunst.service && mako"; }

        # Turn off screen after 5 minutes of inactivity
        { command = "${pkgs.swayidle}/bin/swayidle -w timeout 300 'swaymsg \"output * dpms off\"' resume 'swaymsg \"output * dpms on\"'"; }

        # Autolock after 10 minutes of inactivity
        { command = "${pkgs.swayidle}/bin/swayidle -w timeout 600 ${lockScript}/bin/swaylock"; }

        # Launch clipboard manager
        { command = "${pkgs.wl-clipboard}/bin/wl-paste -t text --watch ${pkgs.clipman}/bin/clipman store"; }
      ];

      floating = {
        border = 2;

        criteria = [ 
          { title = "Microsoft Teams Notification"; }
        ];
      };

      window = {
        hideEdgeBorders = "smart";
        border = 2;
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
          h = "resize grow width 10 px or 10 ppt";
          j = "resize grow height 10 px or 10 ppt";
          k = "resize shrink height 10 px or 10 ppt";
          l = "resize shrink width 10 px or 10 ppt";

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
          l = "mode default, exec ${lockScript}/bin/swaylock"; 
          e = "mode default, exec swaymsg exit";
          r = "mode default, exec systemctl reboot";
          p = "mode default, exec systemctl poweroff -i";
          c = "mode default, reload";

          Return = "mode default";
          Escape = "mode default";
        };
      };

      input = {
        "*" = { 
          xkb_layout = "fr,fr";
          xkb_variant = "bepo,";
          # to switch keyboard layout
          # see https://github.com/swaywm/sway/issues/1242#issuecomment-556096337
          xkb_options = "grp:alt_caps_toggle";
          xkb_numlock = "enabled";
          tap = "enabled";
        };
      };

      output = {
        "*" = {
          bg = "${wallpaper} stretch";
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
          fonts = [ "monospace 10" ];
          hiddenState = "hide";

          colors = {
            background = "${colors.gray-800}";
            statusline = "${colors.gray-800}";
            separator = "${colors.gray-800}";

            focusedWorkspace  = { border = "${colors.blue-800}";   background = "${colors.blue-800}";   text = "${colors.gray-100}"; };
            activeWorkspace   = { border = "${colors.blue-800}";   background = "${colors.blue-800}";   text = "${colors.gray-100}"; };
            inactiveWorkspace = { border = "${colors.gray-700}";   background = "${colors.gray-800}";   text = "${colors.gray-100}"; };
            urgentWorkspace   = { border = "${colors.red-800}";    background = "${colors.red-800}";    text = "${colors.gray-100}"; };
            bindingMode       = { border = "${colors.purple-500}"; background = "${colors.purple-500}"; text = "${colors.gray-800}"; };
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

    wrapperFeatures.gtk = true;
  };
}
