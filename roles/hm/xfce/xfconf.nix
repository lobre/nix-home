{ pkgs, lib, ... }:

let
  xfconfJson = pkgs.buildGoModule rec {
    pname = "xfconf-json";
    version = "0.0.2";

    src = pkgs.fetchFromGitHub {
      owner = "lobre";
      repo = "xfconf-json";
      rev = "v${version}";
      sha256 = "030P4MwTsO0lJewf+aNmtHLNMF9sDz8l0blshAscpYI=";
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
      "/general/cycle_draw_frame" = true; # blue frame when cycling with alt-tab
      "/general/cycle_preview" = true; # thumbnails when cycling with alt-tab
      "/general/cycle_tabwin_mode" = 0; # don’t cycle through windows in a list
      "/general/wrap_windows" = false; # don’t move window to other workspace when approaching border
    };

    "xfce4-keyboard-shortcuts" = {
      # apps
      "/commands/custom/override" = true; # allow custom commands
      "/commands/custom/<Primary><Alt>l" = "xflock4";
      "/commands/custom/<Primary><Alt>Delete" = "xfce4-session-logout";
      "/commands/custom/<Super>t" = "exo-open --launch TerminalEmulator";
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
      "/xfwm4/custom/<Alt><Shift>Tab" = "cycle_reverse_windows_key";
      "/xfwm4/custom/<Alt>Tab" = "cycle_windows_key";
      "/xfwm4/custom/<Super>Tab" = "switch_window_key";
      "/xfwm4/custom/<Super>d" = "show_desktop_key";
      "/xfwm4/custom/<Super>f" = "fill_window_key";
      "/xfwm4/custom/<Shift><Super>f" = "fullscreen_key";
      "/xfwm4/custom/<Super>m" = "move_window_key";
      "/xfwm4/custom/<Super>q" = "close_window_key";
      "/xfwm4/custom/<Super>r" = "resize_window_key";
      "/xfwm4/custom/<Super>s" = "stick_window_key";
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

      # bottom panel
      "/panels/panel-1/icon-size" = 0;
      "/panels/panel-1/length" = 100;
      "/panels/panel-1/position" = "p=8;x=0;y=0";
      "/panels/panel-1/position-locked" = true;
      "/panels/panel-1/size" = 26;
      "/panels/panel-1/output-name" = "Primary";
      "/panels/panel-1/plugin-ids" = [ 1 2 3 4 5 6 7 8 9 10 11 12 13 ];

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

      # show desktop
      "/plugins/plugin-13" = "showdesktop";
    };

    "keyboards" = {
      "/Default/KeyRepeat/Delay" = 500;
      "/Default/KeyRepeat/Rate" = 100; # to move windows faster
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
