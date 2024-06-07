{ pkgs, ... }:

with pkgs;

let
  luaEnv = lua.withPackages (ps: [ ps.lpeg ]);

  vis = stdenv.mkDerivation {
    pname = "vis";
    version = "2024-05-12";

    src = fetchFromGitHub {
      rev = "a7aac1044856abc4d1f133c6563fc604d7fe6295";
      sha256 = "sha256-8QLl9Q/WBXrDSPxyvZdn0LNlqp17cwH64iVYPGas+PI=";
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
        -- vis:command("set number")
        -- vis:command("set relativenumbers")
    end)

    vis:command_register("pick", function(argv)
        local prompt = ""
        if argv[1] then
            prompt = " -q " .. argv[1]
        end

        local file = io.popen("git ls-files | pick -X" .. prompt)
        local output = file:read()
        file:close()

        if output then
            vis:command(string.format("e '%s'", output))
        end

        vis:feedkeys("<vis-redraw>")
        return true;
    end)

    vis:command_register("grep", function(argv)
        local search = argv[1]

        local file = io.popen("git grep " .. search .. " | pick -X | sed 's/:.*//'")
        local output = file:read()
        file:close()

        if output then
            vis:command(string.format("e '%s'", output))
            vis:feedkeys(string.format("/%s<Enter>", search))
        end

        vis:feedkeys("<vis-redraw>")
        return true;
    end)
  '';
}

