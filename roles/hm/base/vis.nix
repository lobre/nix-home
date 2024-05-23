{ pkgs, ... }:

with pkgs;

let
  luaEnv = lua.withPackages (ps: [ ps.lpeg ]);

  vis = stdenv.mkDerivation {
    pname = "vis";
    version = "2024-05-12";

    src = fetchFromGitHub {
      rev = "777b11c4ebdf752fde6f134f942aa20464d9c8b5";
      sha256 = "sha256-OfUt6qRc1/Myx6NtvlVNS67eR+4BOH0e5QdYRr+twmw=";
      repo = "vis";
      owner = "rnpnr";
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
        vis:command("set theme mydef")
    end)

    vis.events.subscribe(vis.events.WIN_OPEN, function(win)
        vis:command("set number")
        vis:command("set relativenumbers")
    end)
  '';
}

