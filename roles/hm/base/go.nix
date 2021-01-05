{ pkgs, ... }:

{
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

