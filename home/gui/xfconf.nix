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

  config = {
    "xfce4-panel" = {
      "/toto" = 2;
    };
  };

  configFile = pkgs.writeText "xfconf.json" (builtins.toJSON config);
in

{
  home.packages = with pkgs; [];

  home.activation.xfconfSettings = lib.hm.dag.entryAfter ["installPackages"] ''
    if [[ -v DRY_RUN ]]; then
      ${xfconfJson}/bin/xfconf-json -bin ${pkgs.xfce.xfconf}/bin/xfconf-query -file ${configFile} -bash
    else
      ${xfconfJson}/bin/xfconf-json -bin ${pkgs.xfce.xfconf}/bin/xfconf-query -file ${configFile}
    fi
  '';
}


