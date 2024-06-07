{ pkgs, ... }:

let
  kakoune = pkgs.kakoune-unwrapped.overrideAttrs (oldAttrs: {
    pname = "kakoune-unwrapped";
    version = "2024-02-05";

    patches = [ ];

    src = pkgs.fetchFromGitHub {
      owner = "mawww";
      repo = "kakoune";
      rev = "1c352e996c265cb0b1a6eb5478f171916ccb605f";
      sha256 = "sha256-fDcSLbvbGEyQHDj64HPOozI1Y3gNxjcnmg2GYSk1m2s=";
    };
  });

  kak-lsp = pkgs.rustPlatform.buildRustPackage rec {
    pname = "kak-lsp";
    version = "2024-05-13";

    src = pkgs.fetchFromGitHub {
      owner = pname;
      repo = pname;
      rev = "55299017570dce3ac39d2084fbd417348418d9c6";
      sha256 = "sha256-emPzZ87+9vKURKybfLoRg/jQxNfMfboRekSU1v/SzF4=";
    };

    cargoSha256 = "sha256-l6s2NtXowyjNEaUcZKMjk1FSZa7EZGX5qmLboLMNZLI=";
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
      hook global WinSetOption filetype=(go|zig|php|nix) %{
        lsp-enable-window
        lsp-inlay-diagnostics-enable window
        hook window BufWritePre .* lsp-formatting-sync
      }

      colorscheme off

      set global indentwidth 4
      set global ui_options terminal_set_title=false terminal_assistant=none terminal_enable_mouse=true
      set global autoinfo ""
      set global autocomplete prompt

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

      hook global RawKey <c-mouse:press:right:.*> %{ try "exec gf" }
      hook global RawKey <c-scroll:[^-].*> %{ try "exec 3vk<c-i>" }
      hook global RawKey <c-scroll:-.*> %{ try "exec 3vj<c-o>" }

      hook global NormalKey "n|<a-n>" %{ exec -draft vv }

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

      map global normal <space> %{:enter-user-mode lsp<ret>}
    '';
  };

  # lsp configurations
  xdg.configFile."kak-lsp/kak-lsp.toml".text = with pkgs; ''
    snippet_support = true

    [language.go]
    filetypes = ["go"]
    roots = ["go.mod", ".git"]
    command = "${gopls}/bin/gopls"

    [language.nix]
    filetypes = ["nix"]
    roots = ["flake.nix", "shell.nix", ".git"]
    command = "${nil}/bin/nil"
    [language.nix.settings.nil.formatting]
    command = [ "${pkgs.nixpkgs-fmt}/bin/nixpkgs-fmt" ]

    [language.php]
    filetypes = ["php"]
    roots = ["composer.json", ".git"]
    command = "${phpactor}/bin/phpactor"
    args = ["language-server"]

    [language.zig]
    filetypes = ["zig"]
    roots = ["build.zig"]
    command = "${zls}/bin/zls"
  '';
}

