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
in

{
  home.packages = with pkgs; [
    elmPackages.elm
    elmPackages.elm-format
    elmPackages.elm-review
    elmPackages.elm-test

    nodejs
    tailwindcss

    sqlite-interactive

    php81
    php81Packages.composer

    cargo
    rustc
    rustfmt

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
}

