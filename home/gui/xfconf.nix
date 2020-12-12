{ config, pkgs, lib, ... }:

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
    };

    "xfce4-desktop" = {
      "/backdrop/screen0/monitoreDP-1/workspace0/last-image" = "${wallpaper}/wallpaper.jpg";
      "/backdrop/screen0/monitoreDP-1/workspace0/image-style" = 4; # scaled
      "/desktop-icons/style" = 0;
    };

    "xsettings" = {
      "/Net/ThemeName" = "Arc-Darker";
      "/Net/IconThemeName" = "ePapirus";
    };
    
    "xfwm4" = {
      "/general/theme" = "Arc-Darker";
      "/general/vblank_mode" = "glx"; # seems to better work with external monitors
      "/general/workspace_count" = 4;
      "/general/easy_click" = "Super"; # key used to grab and move windows
    };

    "xfce4-keyboard-shortcuts" = {
      "/commands/custom/<Super>Return" = "exo-open --launch TerminalEmulator";
      "/commands/custom/<Super>g" = "xfce4-screenshooter";
      "/commands/custom/<Super>l" = "xflock4";
      "/commands/custom/<Super>space" = "xfce4-popup-whiskermenu";
      "/commands/custom/<Super>v" = "xfce4-popup-clipman";
    };

    "xfcfe4-panel" = {
      "/panels" = [ 1 2 ];

      # top panel
      "/panels/panel-1/icon-size" = 16;
      "/panels/panel-1/length" = 100;
      "/panels/panel-1/position" = "p=6;x=0;y=0";
      "/panels/panel-1/position-locked" = true;
      "/panels/panel-1/size" = 26;
      "/panels/panel-1/plugin-ids" = [ 1 2 3 4 5 6 7 8 9 10 11 12 13 14 ];

      # bottom panel (let dynamically add plugins)
      "/panels/panel-2/autohide-behavior" = 1;
      "/panels/panel-2/position" = "p=10;x=0;y=0";
      "/panels/panel-2/position-locked" = true;
      "/panels/panel-2/size" = 48;

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
      "/plugins/plugin-6/show-frame" = false;
      "/plugins/plugin-6/square-icons" = true;

      # audio
      "/plugins/plugin-7" = "pulseaudio";
      "/plugins/plugin-7/enable-key-shortcuts" = true;
      "/plugins/plugin-7/show-notifications" = true;

      # notifications
      "/plugins/plugin-8" = "notification-plugin";

      # battery
      "/plugins/plugin-9" = "battery";

      # disk
      "/plugins/plugin-10" = "fsguard";

      # clipboard
      "/plugins/plugin-11" = "xfce4-clipman-plugin";

      # screenshot
      "/plugins/plugin-12" = "screenshooter";

      # sep
      "/plugins/plugin-13" = "separator";
      "/plugins/plugin-13/style" = 0;

      # clock
      "/plugins/plugin-14" = "clock";
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
