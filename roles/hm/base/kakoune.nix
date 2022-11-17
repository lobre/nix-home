{ config, pkgs, ... }:

{
  # colorscheme
  xdg.configFile."kak/colors/ansi.kak".source = ./ansi.kak;

  programs.kakoune = {
    enable = true;

    config = {
      colorScheme = "ansi";
      indentWidth = 4;
      showMatching = true;

      ui = {
        assistant = "none";
        enableMouse = true;
        setTitle = true;
      };

      hooks = [
        {
          name = "BufSetOption";
          option = "filetype=go";
          commands = ''
            set-option buffer indentwidth 0
            set-option buffer formatcmd '${pkgs.gotools}/bin/goimports | ${config.programs.go.package}/bin/gofmt'
            hook buffer BufWritePre .* format
          '';
        }
        {
          name = "BufSetOption";
          option = "filetype=zig";
          commands = ''
            set-option buffer indentwidth 4
            set-option buffer formatcmd '${pkgs.zig}/bin/zig fmt --stdin'
            hook buffer BufWritePre .* format
          '';
        }
        {
          name = "BufSetOption";
          option = "filetype=elm";
          commands = ''
            set-option buffer indentwidth 4
            set-option buffer formatcmd '${pkgs.elmPackages.elm-format}/bin/elm-format --stdin'
            hook buffer BufWritePre .* format
          '';
        }
        {
          name = "BufSetOption";
          option = "filetype=nix";
          commands = ''
            set-option buffer indentwidth 2
            set-option buffer formatcmd ${pkgs.nixfmt}/bin/nixfmt
            hook buffer BufWritePre .* format
          '';
        }
        {
          name = "BufSetOption";
          option = "filetype=html";
          commands = ''
            set-option buffer indentwidth 2
          '';
        }
        {
          name = "BufSetOption";
          option = "filetype=json";
          commands = ''
            set-option buffer indentwidth 2
          '';
        }
        {
          name = "WinCreate";
          option = ".*";
          commands = "wrap-enable";
        }
      ];

      keyMappings = [
        {
          mode = "user";
          key = "y";
          effect = "<a-|>${pkgs.xsel}/bin/xsel --input --clipboard<ret>";
          docstring = "yank to clipboard";
        }
        {
          mode = "user";
          key = "p";
          effect = "<a-!>${pkgs.xsel}/bin/xsel --output --clipboard<ret>";
          docstring = "paste after from clipboard";
        }
        {
          mode = "user";
          key = "P";
          effect = "!${pkgs.xsel}/bin/xsel --output --clipboard<ret>";
          docstring = "paste before from clipboard";
        }
        {
          mode = "user";
          key = "R";
          effect = "|${pkgs.xsel}/bin/xsel --output --clipboard<ret>";
          docstring = "replace from clipboard";
        }
      ];
    };

    extraConfig = ''
      set global startup_info_version 20211108
      set global autocomplete prompt

      declare-option str-list findcmd git ls-files --recurse-submodules
      declare-option str-list numberflags -separator ' ' -hlcursor
      declare-option str-list listflags -tab '→' -spc '·' -nbsp '␣' -lf '↲'

      def find -params 1 -shell-script-candidates "%opt{findcmd}" %{edit %arg{1}}

      def number-enable %{ add-highlighter global/number number-lines %opt{numberflags} }
      def number-disable "remove-highlighter global/number"

      def list-enable %{ add-highlighter window/list show-whitespaces %opt{listflags} }
      def list-disable "remove-highlighter window/list"

      def wrap-enable "add-highlighter window/wrap wrap"
      def wrap-disable "remove-highlighter window/wrap"
    '';
  };
}

