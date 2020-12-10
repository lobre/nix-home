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

  config = {
    "xfce4-session" = {
      "/general/LockCommand" = "light-locker-command --lock";
    };
    "xsettings" = {
      "/Net/ThemeName" = "Arc-Darker";
      "/Net/IconThemeName" = "ePapirus";
    };
    "xfww4" = {
      "/general/theme" = "Arc-Darker";
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
