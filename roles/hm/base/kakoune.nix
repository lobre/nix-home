{ config, pkgs, ... }:

{
  # colorscheme
  xdg.configFile."kak/colors/ansi.kak".source = ./ansi.kak;

  programs.kakoune = {
    enable = true;

    extraConfig = ''
      # hide changelog on startup
      set global startup_info_version 20211108

      # theme
      colorscheme ansi

      # default options
      set global indentwidth 4
      set global ui_options terminal_set_title=true terminal_assistant=none terminal_enable_mouse=true
      set global autocomplete prompt

      # show matching characters
      add-highlighter global/ show-matching

      # find and open a git file quickly
      def find -params 1 -shell-script-candidates "git ls-files --recurse-submodules" %{edit %arg{1}}

      # command to show line numbers
      declare-option str-list numberflags -separator ' ' -hlcursor
      def number-enable %{ add-highlighter global/number number-lines %opt{numberflags} }
      def number-disable "remove-highlighter global/number"

      # command to show hidden characters
      declare-option str-list listflags -tab '→' -spc '·' -nbsp '␣' -lf '↲'
      def list-enable %{ add-highlighter window/list show-whitespaces %opt{listflags} }
      def list-disable "remove-highlighter window/list"

      # command to disable wrapping
      def wrap-enable "add-highlighter window/wrap wrap"
      def wrap-disable "remove-highlighter window/wrap"
      hook global WinCreate .* "wrap-enable"

      hook global BufSetOption filetype=go %{
        set buffer indentwidth 0
        set buffer formatcmd '${pkgs.gotools}/bin/goimports | ${config.programs.go.package}/bin/gofmt'
        hook buffer BufWritePre .* format

        set buffer ctagscmd "ctags -R --fields=+S --languages=go --exclude=testdata --exclude=*test.go --exclude=internal --exclude=cmd"
        set buffer ctagspaths %sh{ echo ". $GOROOT/src" }
      }

      hook global BufSetOption filetype=zig %{
        set buffer indentwidth 4
        set buffer formatcmd '${pkgs.zig}/bin/zig fmt --stdin'
        hook buffer BufWritePre .* format
      }

      hook global BufSetOption filetype=elm %{
        set buffer indentwidth 4
        set buffer formatcmd '${pkgs.elmPackages.elm-format}/bin/elm-format --stdin'
        hook buffer BufWritePre .* format
      }

      hook global BufSetOption filetype=nix %{
        set buffer indentwidth 2
        set buffer formatcmd ${pkgs.nixfmt}/bin/nixfmt
        hook buffer BufWritePre .* format
      }

      hook global BufSetOption filetype=(html|json) "set buffer indentwidth 2"

      # clipboard mappings
      map global user y "<a-|>${pkgs.xsel}/bin/xsel --input --clipboard<ret>"  -docstring "yank from clipboard"
      map global user p "<a-!>${pkgs.xsel}/bin/xsel --output --clipboard<ret>" -docstring "paste after from clipboard"
      map global user P "!${pkgs.xsel}/bin/xsel --output --clipboard<ret>"     -docstring "paste before from clipboard"
      map global user R "|${pkgs.xsel}/bin/xsel --output --clipboard<ret>"     -docstring "replace from clipboard"
    '';
  };
}

