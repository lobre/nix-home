{ config, pkgs, ... }:

let
  nixGL = fetchTarball "https://github.com/guibou/nixGL/archive/master.tar.gz";

  myNixGL = (import "${nixGL}/default.nix" {
      pkgs = pkgs;
  }).nixGLDefault;
in

{
  # Enable settings that make home manager work better on Linux distribs other than NixOS
  targets.genericLinux.enable = true;

  # To fix glibc locale bug (https://github.com/NixOS/nixpkgs/issues/38991)
  home.sessionVariables.LOCALE_ARCHIVE_2_27 = "${pkgs.glibcLocales}/lib/locale/locale-archive";

  # Fix Open GL issues by forcing mesa drivers
  nixpkgs.overlays = [
    (
      self: super: {
        alacritty = super.writeScriptBin "alacritty" ''
          #!${super.stdenv.shell}
          exec ${myNixGL}/bin/nixGL ${super.alacritty}/bin/alacritty "$@"
        '';
      }
    )
    (
      self: super: {
        picom = super.writeScriptBin "picom" ''
          #!${super.stdenv.shell}
          exec ${myNixGL}/bin/nixGL ${super.picom}/bin/picom "$@"
        '';
      }
    )
  ];

}
