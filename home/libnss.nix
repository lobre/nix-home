{ config, pkgs, ... }:

{
  # Fix some packages not finding libnss library
  nixpkgs.overlays = [
    (
      self: super: {
        i3lock-fancy = super.writeScriptBin "i3lock-fancy" ''
          #!${super.stdenv.shell}
          export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/lib/x86_64-linux-gnu
          exec ${super.i3lock-fancy}/bin/i3lock-fancy "$@"
        '';
      }
    )
  ];

}

