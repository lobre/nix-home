{ pkgs, ... }:

{
  # colorscheme
  xdg.configFile."kak/colors/ansi.kak".source = ./ansi.kak;

  programs.kakoune = {
    enable = true;

    config = {
      colorScheme = "ansi";
      indentWidth = 4;
      tabStop = 4;
      showMatching = true;

      ui = {
        assistant = "none";
        enableMouse = true;
      };
    };

    extraConfig = ''
      def find -params 1 -shell-script-candidates %{ git ls-files } %{ edit %arg{1} }

      # hide changelog on startup
      set global startup_info_version 20211108
    '';
  };
}

