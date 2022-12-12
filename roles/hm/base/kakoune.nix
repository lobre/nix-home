{ config, lib, pkgs, ... }:

let
  kakoune = pkgs.kakoune-unwrapped.overrideAttrs (oldAttrs: rec {
    pname = "kakoune-unwrapped";
    version = "2022-12-02";
    src = pkgs.fetchFromGitHub {
      owner = "mawww";
      repo = "kakoune";
      rev = "084fc5eb5af5b0185466553bb1ac62f24bd8291e";
      sha256 = "sha256-7iqTqWnVlcj3zxVYxxn4+EgvUSMX0daizhiCuXYmjf8=";
    };
  });

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
in
{
  # colorscheme
  xdg.configFile."kak/colors/ansi.kak".source = ./ansi.kak;

  programs.kakoune = {
    enable = true;
    package = kakoune;

    extraConfig = ''
      # hide changelog on startup
      set global startup_info_version 20221031

      # enable lsp
      eval %sh{${kak-lsp}/bin/kak-lsp --kakoune -s $kak_session}

      # theme
      colorscheme ansi

      # default options
      set global indentwidth 4
      set global ui_options terminal_set_title=true terminal_assistant=none terminal_enable_mouse=true
      set global autocomplete prompt
      set global autoinfo command
      set global grepcmd 'grep --exclude=tags --exclude-dir=.git -RIHn'

      # default x11 is xfce terminal
      hook global KakBegin .* %{ try %{ set global termcmd 'xfce4-terminal -x sh -c' } }

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
      hook global WinSetOption filetype=(?!grep).+ "git show-diff"
      hook global BufWritePost .* "git update-diff"
      hook global BufReload .* "git update-diff"

      # include ctags entries in completions
      hook global WinSetOption filetype=.+ "ctags-enable-autocomplete"

      hook global WinSetOption filetype=go %{
        set buffer indentwidth 0
        set buffer ctagscmd "ctags -R --fields=+S --languages=go --exclude=testdata --exclude=*test.go --exclude=internal --exclude=cmd"
        set buffer ctagspaths %sh{ echo ". $GOROOT/src" }

        lsp-enable-window
        hook buffer BufWritePre .* lsp-formatting-sync
      }

      hook global WinSetOption filetype=zig %{
        set buffer indentwidth 4
        lsp-enable-window
        hook buffer BufWritePre .* lsp-formatting-sync
      }

      hook global WinSetOption filetype=elm %{
        set buffer indentwidth 4
        lsp-enable-window
        hook buffer BufWritePre .* lsp-formatting-sync
      }

      hook global WinSetOption filetype=nix %{
        set buffer indentwidth 2
        lsp-enable-window
        hook buffer BufWritePre .* lsp-formatting-sync
      }

      hook global WinSetOption filetype=(html|json|xml) "set buffer indentwidth 2"

      hook global WinSetOption filetype=git-commit %{
        set-option window autowrap_column 72
        set-option window autowrap_format_paragraph true
        autowrap-enable
      }

      # mappings
      map global normal '#' ':comment-line<ret>'
      map global normal <c-p> '<esc>:prompt -shell-script-candidates %{ git ls-files --recurse-submodules } file: %{ edit %val{text} }<ret>' -docstring "file"

      # goto mappings
      map global goto p '<esc>[pk' -docstring "previous paragraph"
      map global goto n '<esc>]p;' -docstring "next paragraph"

      # clipboard mappings
      map global user y '<a-|>${pkgs.xsel}/bin/xsel --input --clipboard<ret>'  -docstring "yank from clipboard"
      map global user p '<a-!>${pkgs.xsel}/bin/xsel --output --clipboard<ret>' -docstring "paste after from clipboard"
      map global user P '!${pkgs.xsel}/bin/xsel --output --clipboard<ret>'     -docstring "paste before from clipboard"
      map global user R '|${pkgs.xsel}/bin/xsel --output --clipboard<ret>'     -docstring "replace from clipboard"
    '';
  };

  # lsp configurations
  xdg.configFile."kak-lsp/kak-lsp.toml".text = with pkgs; ''
    [language.elm]
    filetypes = ["elm"]
    roots = ["elm.json"]
    command = "${elmPackages.elm-language-server}/bin/elm-language-server"
    args = ["--stdio"]

    [language.go]
    filetypes = ["go"]
    roots = ["go.mod", ".git"]
    command = "${gopls}/bin/gopls"

    [language.nix]
    filetypes = ["nix"]
    roots = ["flake.nix", "shell.nix", ".git"]
    command = "${rnix-lsp}/bin/rnix-lsp"

    [language.zig]
    filetypes = ["zig"]
    roots = ["build.zig"]
    command = "${zls}/bin/zls"
  '';
}

