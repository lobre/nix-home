{ pkgs, ... }:

let
  kakoune = pkgs.kakoune-unwrapped.overrideAttrs (oldAttrs: {
    pname = "kakoune-unwrapped";
    version = "2024-09-18";

    patches = [ ];

    src = pkgs.fetchFromGitHub {
      owner = "mawww";
      repo = "kakoune";
      rev = "0e225db00efb33150e98e951de9a1b5c72971b12";
      sha256 = "sha256-JsQHorgBl51Tl4z9bLGDRv/KFswGUAWcgp+nSlyXzFQ=";
    };
  });

  kak-lsp = pkgs.rustPlatform.buildRustPackage rec {
    pname = "kak-lsp";
    version = "2024-08-09";

    src = pkgs.fetchFromGitHub {
      owner = pname;
      repo = pname;
      rev = "ebd370f43cb6e7af634e5f8cadb99cc8c16e1efe";
      sha256 = "sha256-wPCu/VxAMIB+zI0+eDq7lJ/rHJZfe0whYzdoiwrixCc=";
    };

    cargoSha256 = "sha256-nBZjaEZ2BrVb3xgz3DhZk7TM5HSfLtiTYsJ6QOxi73s=";
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

      def split -params .. %{ set local windowing_placement vertical; new "%arg{@}" }
      def col -params .. %{ set local windowing_placement horizontal; new "%arg{@}" }

      complete-command split command
      complete-command col command

      def -params 1 assign %{ set global "%arg{1}client" %val{client} }
      complete-command assign shell-script-candidates %{ printf 'jump\ntools\ndocs\n' }

      def yank %{ exec "<a-|>xsel -bi<ret>" }
      def paste %{ set-register dquote %sh{ xsel -b } }

      def mkdir %{ nop %sh{ mkdir -p $(dirname $kak_buffile) } }
      def chmod %{ nop %sh{ chmod +x $kak_buffile } }

      def bind -params 1 %{ map global user %arg{1} "<esc>:edit %val{bufname}<ret>" }

      def -hidden yank-ref %{
        evaluate-commands -draft %{
          execute-keys ',;x'
          set-register dquote "%val{bufname}:%val{cursor_line}:%val{selection}"
        }
      }

      def -hidden goto %{ evaluate-commands %{
        require-module jump
        try %{ exec <a-i><a-w>gf } catch %{ jump }
      }}

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

      map -docstring 'tag' global object t 'c<lt>\w[\w-]*\h*[^<gt>]*?(?<lt>!/)<gt>,<lt>/\w[\w-]*(?<lt>!/)<gt><ret>'

      map global normal <a-y> %{:yank-ref<ret>}
      map global normal <ret> %{:goto<ret>}
      map global user <space> %{<esc>:git edit<space>}
      map global user s %{<esc>:edit -scratch *scratch*<ret>}
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

