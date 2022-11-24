{ config, pkgs, ... }:

let
  kak-lsp = pkgs.rustPlatform.buildRustPackage rec {
    pname = "kak-lsp";
    version = "14.1.0";

    src = pkgs.fetchFromGitHub {
      owner = pname;
      repo = pname;
      rev = "v${version}";
      sha256 = "sha256-5eGp11qPLT1fen39bZmICReK2Ly8Kg9Y3g30ZV0gk04=";
    };

    cargoSha256 = "sha256-+Sj+QSSXJAgGulMLRCWLgddVG8sIiHaB1xWPojVCgas=";
  };
in {
  # colorscheme
  xdg.configFile."kak/colors/ansi.kak".source = ./ansi.kak;

  programs.kakoune = {
    enable = true;

    extraConfig = ''
      # hide changelog on startup
      set global startup_info_version 20211108

      # enable lsp
      eval %sh{${kak-lsp}/bin/kak-lsp --kakoune -s $kak_session}
      set global lsp_auto_show_code_actions true
      lsp-inlay-hints-enable       global
      lsp-inlay-diagnostics-enable global
      lsp-auto-signature-help-enable
      map global user l %{:enter-user-mode lsp<ret>} -docstring "lsp mode"

      # theme
      colorscheme ansi

      # default options
      set global indentwidth 4
      set global ui_options terminal_set_title=true terminal_assistant=none terminal_enable_mouse=true
      set global autocomplete prompt

      # show matching characters
      add-highlighter global/ show-matching

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

      # update git diff in gutter
      hook global WinCreate .* %{
        eval "git show-diff"
        hook buffer BufWritePost .* "git update-diff"
        hook buffer BufReload .* "git update-diff"
      }

      hook global WinSetOption filetype=go %{
        set buffer indentwidth 0
        set buffer formatcmd '${pkgs.gotools}/bin/goimports | ${config.programs.go.package}/bin/gofmt'
        hook buffer BufWritePre .* format
        lsp-enable-window

        set buffer ctagscmd "ctags -R --fields=+S --languages=go --exclude=testdata --exclude=*test.go --exclude=internal --exclude=cmd"
        set buffer ctagspaths %sh{ echo ". $GOROOT/src" }
      }

      hook global WinSetOption filetype=zig %{
        set buffer indentwidth 4
        set buffer formatcmd '${pkgs.zig}/bin/zig fmt --stdin'
        hook buffer BufWritePre .* format
        lsp-enable-window
      }

      hook global WinSetOption filetype=elm %{
        set buffer indentwidth 4
        set buffer formatcmd '${pkgs.elmPackages.elm-format}/bin/elm-format --stdin'
        hook buffer BufWritePre .* format
      }

      hook global WinSetOption filetype=nix %{
        set buffer indentwidth 2
        set buffer formatcmd ${pkgs.nixfmt}/bin/nixfmt
        hook buffer BufWritePre .* format
      }

      hook global WinSetOption filetype=(html|json) "set buffer indentwidth 2"

      hook global WinSetOption filetype=git-commit %{
        set-option window autowrap_column 72
        set-option window autowrap_format_paragraph true
        autowrap-enable
      }

      # mappings
      map global normal "#" ":comment-line<ret>"
      map global user "f" '<esc>:prompt -shell-script-candidates %{ git ls-files --recurse-submodules } file: %{ edit %val{text} }<ret>' -docstring "file"
      map global user "b" '<esc>:prompt -buffer-completion buffer: %{ buffer %val{text} }<ret>' -docstring "buffer"

      # clipboard mappings
      map global user y "<a-|>${pkgs.xsel}/bin/xsel --input --clipboard<ret>"  -docstring "yank from clipboard"
      map global user p "<a-!>${pkgs.xsel}/bin/xsel --output --clipboard<ret>" -docstring "paste after from clipboard"
      map global user P "!${pkgs.xsel}/bin/xsel --output --clipboard<ret>"     -docstring "paste before from clipboard"
      map global user R "|${pkgs.xsel}/bin/xsel --output --clipboard<ret>"     -docstring "replace from clipboard"
    '';
  };

  # lsp configurations
  xdg.configFile."kak-lsp/kak-lsp.toml".text = ''
    [language.go]
    filetypes = ["go"]
    roots = ["go.mod", ".git"]
    command = "${pkgs.gopls}/bin/gopls"

    [language.zig]
    filetypes = ["zig"]
    roots = ["build.zig"]
    command = "${pkgs.zls}/bin/zls"
  '';
}

