{ pkgs, ... }:

{
  # colorscheme
  xdg.configFile."kak/colors/default.kak".source = ./theme.kak;

  programs.kakoune = {
    enable = true;
    extraConfig = ''
      set global ui_options terminal_assistant=none

      map global normal { '<a-:> <a-;> [p'
      map global normal } '<a-:> ]p'
    '';
  };
}

