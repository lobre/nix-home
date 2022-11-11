{ pkgs, ... }:

let
  tailwindcss = pkgs.nodePackages.tailwindcss.overrideAttrs (oldAttrs: {
    plugins = [
      pkgs.nodePackages."@tailwindcss/aspect-ratio"
      pkgs.nodePackages."@tailwindcss/forms"
      pkgs.nodePackages."@tailwindcss/line-clamp"
      pkgs.nodePackages."@tailwindcss/typography"
    ];
  });

in {
  home.packages = with pkgs; [
    elmPackages.elm
    elmPackages.elm-review
    elmPackages.elm-test

    nodejs
    tailwindcss

    sqlite-interactive

    php81
    php81Packages.composer

    zig
  ];

  programs.go = {
    enable = true;
    package = pkgs.go;
    goPath = "go"; # to create GOPATH env variable
  };

  home.sessionVariables.GOROOT = "${pkgs.go}/share/go";

  programs.bash.profileExtra = ''
    # Add go bin in PATH if not already existing
    [[ ":$PATH:" != *":$GOPATH/bin:"* ]] && export PATH="$PATH:$GOPATH/bin"
  '';

  # Zig ctags support
  xdg.configFile."ctags/zig.ctags".text = ''
    --langdef=Zig
    --langmap=Zig:.zig
    --regex-Zig=/fn +([a-zA-Z0-9_]+) *\(/\1/f,functions,function definitions/
    --regex-Zig=/(var|const) *([a-zA-Z0-9_]+) *= *(extern|packed)? *struct/\2/s,structs,struct definitions/
    --regex-Zig=/(var|const) *([a-zA-Z0-9_]+) *= *(extern|packed)? *enum/\2/e,enums,enum definitions/
    --regex-Zig=/(var|const) *([a-zA-Z0-9_]+) *= *(extern|packed)? *union/\2/u,unions,union definitions/
    --regex-Zig=/(var|const) *([a-zA-Z0-9_]+) *= *error/\2/E,errors,error definitions/
  '';
}

