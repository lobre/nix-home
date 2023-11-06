{ pkgs, ... }:

with pkgs;

let
  luaEnv = lua.withPackages (ps: [ ps.lpeg ]);

  vis = stdenv.mkDerivation {
    pname = "vis";
    version = "2023-10-17";

    src = fetchFromGitHub {
      rev = "045ef7a102e86f85ea71864c6a12ecb90250f935";
      sha256 = "sha256-rN8efCM+grE4U6z0HpRj+7gD0kh2H7CFPn9NBc7PN9M=";
      repo = "vis";
      owner = "martanne";
    };

    nativeBuildInputs = [ pkg-config makeWrapper ];

    buildInputs = [ ncurses libtermkey luaEnv tre acl libselinux ];

    postPatch = ''
      patchShebangs ./configure
    '';

    postInstall = ''
      wrapProgram $out/bin/vis \
        --prefix LUA_CPATH ';' "${luaEnv}/lib/lua/${lua.luaversion}/?.so" \
        --prefix LUA_PATH ';' "${luaEnv}/share/lua/${lua.luaversion}/?.lua" \
        --prefix VIS_PATH : "\$HOME/.config:$out/share/vis"
    '';
  };
in

{
  home.packages = [ vis ];

  xdg.configFile."vis/themes/ansi.lua".source = ./ansi.lua;

  xdg.configFile."vis/visrc.lua".text = ''
    require('vis')

    vis.events.subscribe(vis.events.INIT, function()
        vis:command("set theme mine")
    end)

    vis.events.subscribe(vis.events.WIN_OPEN, function(win)
        vis:command("set number")
        vis:command("set relativenumbers")
    end)
  '';
}

