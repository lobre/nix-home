{ pkgs, lib, ... }:

let
  xfconfJson = pkgs.buildGoModule rec {
    pname = "xfconf-json";
    version = "0.0.1";

    src = pkgs.fetchFromGitHub {
      owner = "lobre";
      repo = "xfconf-json";
      rev = "v${version}";
      sha256 = "1iy88pb6k6vpmq73r26h21ibwkqs2698r54iyicjdg3f421p588f";
    };

    vendorSha256 = "1fzlslz9xr3jay9kpvrg7sj1a0c1f1m1kn5rnis49hvlr1sc00d0";

    meta = with lib; {
      description = "A xfconf-query wrapper to apply configurations from a json file";
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

  wallpaper = pkgs.stdenv.mkDerivation {
    pname = "wallpaper";
    version = "0.0.1";
    src = ./.;
    installPhase = ''
      mkdir -p $out
      cp wallpaper.jpg $out/wallpaper.jpg
    '';
  };

  config = {
    "xfce4-session" = {
      "/general/LockCommand" = "light-locker-command --lock";
      "/startup/ssh-agent/enabled" = false;
      "/startup/gpg-agent/enabled" = false;
    };

    "xfce4-desktop" = {
      "/backdrop/screen0/monitoreDP-1/workspace0/last-image" = "${wallpaper}/wallpaper.jpg";
      "/backdrop/screen0/monitoreDP-1/workspace0/image-style" = 5; # zoomed
      "/desktop-icons/style" = 0;
    };

    "xsettings" = {
      "/Net/ThemeName" = "Adwaita";
      "/Net/IconThemeName" = "Adwaita";
    };

    "xfwm4" = {
      "/general/workspace_count" = 4;
      "/general/easy_click" = "Super"; # key used to grab and move windows
      "/general/snap_to_windows" = true;
      "/general/activate_action" = "switch";
      "/general/wrap_cycle" = false; # don't cycle to first workspace after last
      "/general/cycle_draw_frame" = true; # blue frame when cycling with alt-tab
      "/general/cycle_preview" = false; # no thumbnails when cycling with alt-tab
      "/general/cycle_tabwin_mode" = 1; # cycle through windows in a list
    };

    "xfce4-keyboard-shortcuts" = {
      # apps
      "/commands/custom/override" = true; # allow custom commands
      "/commands/custom/<Primary><Alt>l" = "xflock4";
      "/commands/custom/<Primary><Alt>Delete" = "xfce4-session-logout";
      "/commands/custom/<Super>Return" = "exo-open --launch TerminalEmulator";
      "/commands/custom/<Super>space" = "xfce4-popup-whiskermenu";
      "/commands/custom/<Super>v" = "xfce4-popup-clipman";
      "/commands/custom/<Super>e" = "thunar";

      # allow custom wm keybindings
      "/xfwm4/custom/override" = true;

      # directions
      "/xfwm4/custom/h" = "left_key";
      "/xfwm4/custom/j" = "down_key";
      "/xfwm4/custom/k" = "up_key";
      "/xfwm4/custom/l" = "right_key";

      # windows
      "/xfwm4/custom/<Alt>Tab" = "cycle_windows_key";
      "/xfwm4/custom/<Alt><Shift>Tab" = "cycle_reverse_windows_key";
      "/xfwm4/custom/<Super>Tab" = "switch_window_key";
      "/xfwm4/custom/Escape" = "cancel_key";
      "/xfwm4/custom/<Super>z" = "maximize_window_key";
      "/xfwm4/custom/<Shift><Super>z" = "hide_window_key";
      "/xfwm4/custom/<Super>d" = "show_desktop_key";
      "/xfwm4/custom/<Super>q" = "close_window_key";
      "/xfwm4/custom/<Super>r" = "resize_window_key";
      "/xfwm4/custom/<Super>m" = "move_window_key";
      "/xfwm4/custom/<Super>f" = "fullscreen_key";

      # windows tiling
      "/xfwm4/custom/<Super>h" = "tile_left_key";
      "/xfwm4/custom/<Super>j" = "tile_down_key";
      "/xfwm4/custom/Super>k" = "tile_up_key";
      "/xfwm4/custom/<Super>l" = "tile_right_key";
      "/xfwm4/custom/<Alt><Super>h" = "tile_up_left_key";
      "/xfwm4/custom/<Alt><Super>j" = "tile_down_right_key";
      "/xfwm4/custom/<Alt>Super>k" = "tile_down_left_key";
      "/xfwm4/custom/<Alt><Super>l" = "tile_up_right_key";

      # workspaces
      "/xfwm4/custom/<Primary><Super>l" = "next_workspace_key";
      "/xfwm4/custom/<Primary><Super>h" = "prev_workspace_key";
      "/xfwm4/custom/<Shift><Super>l" = "move_window_next_workspace_key";
      "/xfwm4/custom/<Shift><Super>h" = "move_window_prev_workspace_key";
    };

    "xfce4-panel" = {
      "/panels" = [ 1 2 ];
      "/panels/dark-mode" = true;

      # top panel
      "/panels/panel-1/icon-size" = 0;
      "/panels/panel-1/length" = 100;
      "/panels/panel-1/position" = "p=6;x=0;y=0";
      "/panels/panel-1/position-locked" = true;
      "/panels/panel-1/size" = 26;
      "/panels/panel-1/output-name" = "Primary";
      "/panels/panel-1/plugin-ids" = [ 1 2 3 4 5 6 7 8 9 10 11 12 ];

      # bottom panel (let dynamically add plugins)
      "/panels/panel-2/icon-size" = 0;
      "/panels/panel-2/autohide-behavior" = 1;
      "/panels/panel-2/position" = "p=10;x=0;y=0";
      "/panels/panel-2/position-locked" = true;
      "/panels/panel-2/size" = 48;
      "/panels/panel-2/output-name" = "Primary";

      # menu
      "/plugins/plugin-1" = "whiskermenu";

      # windows
      "/plugins/plugin-2" = "tasklist";
      "/plugins/plugin-2/grouping" = 1;

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
      "/plugins/plugin-6/square-icons" = true;

      # audio
      "/plugins/plugin-7" = "pulseaudio";
      "/plugins/plugin-7/enable-key-shortcuts" = true;
      "/plugins/plugin-7/show-notifications" = true;

      # notifications
      "/plugins/plugin-8" = "notification-plugin";

      # clipboard
      "/plugins/plugin-9" = "xfce4-clipman-plugin";
      "/plugins/clipman/settings/save-on-quit" = true;
      "/plugins/clipman/settings/max-texts-in-history" = 1000;
      "/plugins/clipman/settings/add-primary-clipboard" = false;

      # screenshot
      "/plugins/plugin-10" = "screenshooter";

      # sep
      "/plugins/plugin-11" = "separator";
      "/plugins/plugin-11/style" = 0;

      # clock
      "/plugins/plugin-12" = "clock";
    };

    "xfce4-notifyd" = {
      "/notification-log" = true; # log notifications
      "/log-level" = 0; # only during do not disturb mode
    };

    "xfce4-power-manager" = {
      "/xfce4-power-manager/show-tray-icon" = true;
    };
  };

  configFile = pkgs.writeText "xfconf.json" (builtins.toJSON config);
in

{
  home.packages = with pkgs; [ xfconfDump ];

  home.activation.xfconfSettings = lib.hm.dag.entryAfter ["installPackages"] ''
    if [[ -v DRY_RUN ]]; then
      ${xfconfJson}/bin/xfconf-json -bin ${pkgs.xfce.xfconf}/bin/xfconf-query -file ${configFile} -bash
    else
      ${xfconfJson}/bin/xfconf-json -bin ${pkgs.xfce.xfconf}/bin/xfconf-query -file ${configFile}
    fi
  '';
}
