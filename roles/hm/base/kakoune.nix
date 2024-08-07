{ pkgs, ... }:

let
  kakoune = pkgs.kakoune-unwrapped.overrideAttrs (oldAttrs: {
    pname = "kakoune-unwrapped";
    version = "2024-02-05";

    patches = [ ];

    src = pkgs.fetchFromGitHub {
      owner = "mawww";
      repo = "kakoune";
      rev = "011283e4d2579d905738ef8684972071faad1b7e";
      sha256 = "sha256-cxBS8sfDImyfjbgvPu/FEZmqY7D/q1tMh0DGtN0jq3c=";
    };
  });

  kak-lsp = pkgs.rustPlatform.buildRustPackage rec {
    pname = "kak-lsp";
    version = "2024-05-13";

    src = pkgs.fetchFromGitHub {
      owner = pname;
      repo = pname;
      rev = "ab9bf8078caf028ac4c005624ba94bee169f959d";
      sha256 = "sha256-C/iJRfPxid7tUx5rAuwi8IAUUCfxQKWoj6TeFrjOp/g=";
    };

    cargoSha256 = "sha256-sOUOZ+HE8a8otmfCvv/01/dhzWRuDLMhT/azyKx3K2E=";
  };
in

{
  xdg.configFile."kak/colors/off.kak".source = ./off.kak;

  programs.kakoune = {
    enable = true;
    package = kakoune;
    defaultEditor = true;

    extraConfig = ''
      set global startup_info_version 20241204

      eval %sh{${kak-lsp}/bin/kak-lsp --kakoune -s $kak_session}
      hook global WinSetOption filetype=(go|nix|php|sh|zig) %{
        lsp-enable-window
        lsp-inlay-diagnostics-enable window

        hook window BufWritePre .* %{ lsp-formatting-sync }
        hook global BufWritePre .*[.]go %{ try %{ lsp-code-actions-sync source.organizeImports } }
      }

      colorscheme off

      set global indentwidth 4
      set global ui_options terminal_set_title=false terminal_assistant=none terminal_enable_mouse=true
      set global autoinfo ""
      set global autocomplete prompt|insert

      add-highlighter global/ wrap
      add-highlighter global/ show-whitespaces -only-trailing -lf " " -indent ""

      def split-horizontal -params .. %{ set local windowing_placement vertical; new "%arg{@}" }
      def split-vertical -params .. %{ set local windowing_placement horizontal; new "%arg{@}" }

      complete-command split-horizontal command
      complete-command split-vertical command

      def assign-jumpclient %{ set global jumpclient %val{client} }
      def assign-toolsclient %{ set global toolsclient %val{client} }
      def assign-docsclient %{ set global docsclient %val{client} }

      def yank %{ exec "<a-|>xsel -bi<ret>" }
      def paste %{ set-register dquote %sh{ xsel -b } }

      def mkdir %{ nop %sh{ mkdir -p $(dirname $kak_buffile) } }
      def chmod %{ nop %sh{ chmod +x $kak_buffile } }

      # this does not work when trying to open another kak instance in same directory
      hook global EnterDirectory .* %{ rename-session %sh{ basename $(pwd) } }

      hook global BufOpenFile ^[^*]+$ %{ evaluate-commands %sh{
        if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
          for hook in WinCreate BufReload BufWritePost; do
            echo "hook buffer $hook %val{buffile} 'git show-diff'"
          done
        fi
      }}

      hook global WinSetOption filetype=(go) "set buffer indentwidth 0"
      hook global WinSetOption filetype=(html|json|nix|xml) "set buffer indentwidth 2"
      hook global WinSetOption filetype=(c|zig) "set buffer indentwidth 4"

      hook global WinSetOption filetype=git-commit %{
        set window autowrap_column 72
        set window autowrap_format_paragraph true
        autowrap-enable
      }

      map global normal <space> %{:edit -scratch *scratch*<ret>}

      define-command -params .. pin %{
        evaluate-commands -draft -save-regs al %{
          execute-keys 'xH"ly'
          set-register a "%val{bufname}:%val{cursor_line}:"
          edit -scratch *scratch*
          set-option buffer filetype grep
          execute-keys 'gjo#<space>' "%arg{@}" '<ret><esc>"aP"lp'
        }

        echo "pin added: %arg{@}"
      }
    '';
  };

  # lsp configurations
  xdg.configFile."kak-lsp/kak-lsp.toml".text = ''
    snippet_support = true

    [language_server.bash-language-server]
    filetypes = ["sh"]
    roots = [".git"]
    command = "${pkgs.nodePackages.bash-language-server}/bin/bash-language-server"
    args = ["start"]

    [language_server.gopls]
    filetypes = ["go"]
    roots = ["go.mod", ".git"]
    command = "${pkgs.gopls}/bin/gopls"

    [language_server.nil]
    filetypes = ["nix"]
    roots = ["flake.nix", "shell.nix", ".git"]
    command = "${pkgs.nil}/bin/nil"

    [language_server.nil.settings.nil.formatting]
    command = "${pkgs.nixpkgs-fmt}/bin/nixpkgs-fmt"

    [language_server.phpactor]
    filetypes = ["php"]
    roots = ["composer.json", ".git"]
    command = "${pkgs.phpactor}/bin/phpactor"
    args = ["language-server"]

    [language_server.zls]
    filetypes = ["zig"]
    roots = ["build.zig"]
    command = "${pkgs.zls}/bin/zls"
  '';
}

