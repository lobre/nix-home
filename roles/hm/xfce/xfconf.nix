{ pkgs, lib, ... }:

let
  # replace xfwm4 by i3
  i3 = true;

  xfconfJson = pkgs.buildGoModule rec {
    pname = "xfconf-json";
    version = "0.0.2";

    src = pkgs.fetchFromGitHub {
      owner = "lobre";
      repo = "xfconf-json";
      rev = "v${version}";
      sha256 = "030P4MwTsO0lJewf+aNmtHLNMF9sDz8l0blshAscpYI=";
    };

    vendorHash = "sha256-oAHAdMh0w0R0tLnYGWpwgQEVpD4v7zuTV3Lknj7V9Ls=";

    meta = with lib; {
      description =
        "A xfconf-query wrapper to apply configurations from a json file";
      homepage = "https://github.com/lobre/xfconf-query";
      license = licenses.mit;
    };
  };

  xfconfDump = pkgs.writeScriptBin "xfconf-dump" ''
    #!${pkgs.stdenv.shell}

    for channel in $(${pkgs.xfce.xfconf}/bin/xfconf-query -l | grep -v ':' | tr -d "[:blank:]")
    do
        ${pkgs.xfce.xfconf}/bin/xfconf-query -c $channel -lv | while read line; do echo -e "$channel\t$line"; done
    done
  '';

  config = {
    "xfce4-session" = {
      "/startup/ssh-agent/enabled" = false;
      "/startup/gpg-agent/enabled" = false;

      "/sessions/Failsafe/Client1_Command" = if i3 then [ "${pkgs.i3}/bin/i3" ] else [ "xfwm4" ];
      "/sessions/Failsafe/Client2_Command" = if i3 then [ "true" ] else [ "xfce4-panel" ];
      "/sessions/Failsafe/Client4_Priority" = if i3 then 18 else 35;
      "/sessions/Failsafe/Client4_Command" =
        if i3 then [ "${pkgs.nitrogen}/bin/nitrogen" "--restore" ] else [ "xfdesktop" ];
    };

    "xfce4-appfinder" = {
      "/hide-window-decorations" = false;
      "/always-center" = true;
      "/sort-by-frecency" = true;
      "/remember-category" = true;
    };

    "xfce4-desktop" = {
      "/desktop-icons/style" = 0;
    };

    "xsettings" = {
      "/Net/ThemeName" = "Adwaita";
      "/Net/IconThemeName" = "Adwaita";
    };

    "displays" = {
      "/Notify" = true;
      "/AutoEnableProfiles" = true;
    };

    "xfwm4" = {
      "/general/theme" = "Default";
      "/general/workspace_count" = 4;
      "/general/easy_click" = "Super"; # key used to grab and move windows
      "/general/snap_to_windows" = true;
      "/general/activate_action" = "switch";
      "/general/wrap_cycle" = true; # cycle to first workspace after last
      "/general/cycle_draw_frame" = false; # no blue frame when cycling with alt-tab
      "/general/cycle_preview" = true; # thumbnails when cycling with alt-tab
      "/general/cycle_tabwin_mode" = 0; # don’t cycle through windows in a list
      "/general/wrap_windows" =
        false; # don’t move window to other workspace when approaching border
    };

    "xfce4-keyboard-shortcuts" = {
      # apps
      "/commands/custom/override" = true; # allow custom commands
      "/commands/custom/<Primary><Alt>l" = "xflock4";
      "/commands/custom/<Primary><Alt>Delete" = "xfce4-session-logout";
      "/commands/custom/<Super>Return" = "exo-open --launch TerminalEmulator";
      "/commands/custom/<Super>d" = if i3 then "xfce4-appfinder" else "xfce4-popup-whiskermenu";
      "/commands/custom/<Super>c" = "xfce4-popup-clipman";

      # allow custom wm keybindings
      "/xfwm4/custom/override" = true;

      # directions
      "/xfwm4/custom/h" = "left_key";
      "/xfwm4/custom/j" = "down_key";
      "/xfwm4/custom/k" = "up_key";
      "/xfwm4/custom/l" = "right_key";

      # windows
      "/xfwm4/custom/<Alt><Shift>Tab" = "cycle_reverse_windows_key";
      "/xfwm4/custom/<Alt>Tab" = "cycle_windows_key";
      "/xfwm4/custom/<Super>Tab" = "switch_window_key";
      "/xfwm4/custom/<Super>d" = "show_desktop_key";
      "/xfwm4/custom/<Super>f" = "fullscreen_key";
      "/xfwm4/custom/<Super>m" = "move_window_key";
      "/xfwm4/custom/<Super>q" = "close_window_key";
      "/xfwm4/custom/<Super>r" = "resize_window_key";
      "/xfwm4/custom/<Super>z" = "maximize_window_key";
      "/xfwm4/custom/<Shift><Super>z" = "hide_window_key";
      "/xfwm4/custom/Escape" = "cancel_key";

      # windows tiling
      "/xfwm4/custom/<Super>h" = "tile_left_key";
      "/xfwm4/custom/<Super>j" = "tile_down_key";
      "/xfwm4/custom/<Super>k" = "tile_up_key";
      "/xfwm4/custom/<Super>l" = "tile_right_key";

      # workspaces
      "/xfwm4/custom/<Super>n" = "next_workspace_key";
      "/xfwm4/custom/<Super>p" = "prev_workspace_key";
      "/xfwm4/custom/<Shift><Super>n" = "move_window_next_workspace_key";
      "/xfwm4/custom/<Shift><Super>p" = "move_window_prev_workspace_key";
    };

    "xfce4-panel" = {
      "/panels" = [ 1 ];
      "/panels/dark-mode" = true;

      # panel
      "/panels/panel-1/icon-size" = 0;
      "/panels/panel-1/length" = 100;
      "/panels/panel-1/position" = "p=8;x=0;y=0";
      "/panels/panel-1/position-locked" = true;
      "/panels/panel-1/size" = 22;
      "/panels/panel-1/output-name" = "Primary";
      "/panels/panel-1/plugin-ids" = [ 1 2 3 4 5 6 7 8 9 10 11 12 ];

      # menu
      "/plugins/plugin-1" = "whiskermenu";

      # windows
      "/plugins/plugin-2" = "tasklist";
      "/plugins/plugin-2/grouping" = 1;
      "/plugins/plugin-2/include-all-monitors" = true;
      "/plugins/plugin-2/include-all-workspaces" = false;

      # sep
      "/plugins/plugin-3" = "separator";
      "/plugins/plugin-3/expand" = true;
      "/plugins/plugin-3/style" = 0;

      # workspaces
      "/plugins/plugin-4" = "pager";
      "/plugins/plugin-4/rows" = 1;

      # sep
      "/plugins/plugin-5" = "separator";
      "/plugins/plugin-5/style" = 0;

      # systray 
      "/plugins/plugin-6" = "systray";
      "/plugins/plugin-6/icon-size" = 0; # adjust size automatically
      "/plugins/plugin-6/known-legacy-items" = [ "clipman" "xfce4-power-manager" ];
      "/plugins/plugin-6/square-icons" = true;

      # audio
      "/plugins/plugin-7" = "pulseaudio";
      "/plugins/plugin-7/enable-key-shortcuts" = true;
      "/plugins/plugin-7/show-notifications" = true;

      # notifications
      "/plugins/plugin-8" = "notification-plugin";

      # screenshot
      "/plugins/plugin-9" = "screenshooter";

      # sep
      "/plugins/plugin-10" = "separator";
      "/plugins/plugin-10/style" = 0;

      # clock
      "/plugins/plugin-11" = "clock";
      "/plugins/plugin-11/digital-layout" = 1;
      "/plugins/plugin-11/digital-date-format" = "%d %B %Y";
      "/plugins/plugin-11/digital-date-font" = "Sans 7";
      "/plugins/plugin-11/digital-time-font" = "Sans 10";

      # show desktop
      "/plugins/plugin-12" = "showdesktop";

      # clipboard in systray
      "/plugins/clipman/settings/save-on-quit" = true;
      "/plugins/clipman/settings/max-texts-in-history" = 1000;
      "/plugins/clipman/settings/add-primary-clipboard" = false;
    };

    "keyboards" = {
      "/Default/KeyRepeat/Delay" = 500;
      "/Default/KeyRepeat/Rate" = 50; # to move windows faster
    };

    "xfce4-notifyd" = {
      "/notification-log" = true; # log notifications
      "/log-level" = 0; # only during do not disturb mode
    };

    "xfce4-power-manager" = { "/xfce4-power-manager/show-tray-icon" = true; };

    "xfce4-terminal" =
      let
        black = "#243137";
        red = "#fc3841";
        green = "#5cf19e";
        yellow = "#fed032";
        blue = "#37b6ff";
        magenta = "#fc226e";
        cyan = "#59ffd1";
        white = "#ffffff";

        brightBlack = "#84A6B8";
        brightRed = "#fc746d";
        brightGreen = "#adf7be";
        brightYellow = "#fee16c";
        brightBlue = "#70cfff";
        brightMagenta = "#fc669b";
        brightCyan = "#9affe6";
        brightWhite = "#ffffff";

        background = "#1d262a";
        foreground = "#e7ebed";

        palette =
          "${black};${red};${green};${yellow};${blue};${magenta};${cyan};${white};${brightBlack};${brightRed};${brightGreen};${brightYellow};${brightBlue};${brightMagenta};${brightCyan};${brightWhite}";
      in
      {
        "/cell-height-scale" = 1.1000;
        "/color-background" = "${background}";
        "/color-bold-is-bright" = false;
        "/color-foreground" = "${foreground}";
        "/color-palette" = "${palette}";
        "/font-name" = "Iosevka Term Slab Regular 14";
        "/misc-always-show-tabs" = false;
        "/misc-confirm-close" = false;
        "/misc-default-geometry" = "110x20";
        "/misc-menubar-default" = false;
        "/misc-show-unsafe-paste-dialog" = false;
        "/misc-slim-tabs" = true;
        "/scrolling-bar" = "TERMINAL_SCROLLBAR_NONE";
        "/scrolling-unlimited" = true;
        "/title-mode" = "TERMINAL_TITLE_REPLACE";
      };
  };

  configFile = pkgs.writeText
    "xfconf.json"
    (builtins.toJSON config);

in
{
  home.packages = [ xfconfDump ];

  home.activation.xfconfSettings =
    lib.hm.dag.entryAfter [ "installPackages" ] ''
      if [[ -v DRY_RUN ]]; then
        ${xfconfJson}/bin/xfconf-json -bin ${pkgs.xfce.xfconf}/bin/xfconf-query -file ${configFile} -bash
      else
        ${xfconfJson}/bin/xfconf-json -bin ${pkgs.xfce.xfconf}/bin/xfconf-query -file ${configFile}
      fi
    '';
}
