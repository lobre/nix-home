{ pkgs, ... }:

let
  kakoune = pkgs.kakoune-unwrapped.overrideAttrs (oldAttrs: {
    pname = "kakoune-unwrapped";
    version = "2024-02-05";
    patches = [ ];
    src = pkgs.fetchFromGitHub {
      owner = "mawww";
      repo = "kakoune";
      rev = "e34735a35041c19cc80d24cab6237abd447b8924";
      sha256 = "sha256-Q2hhS6IZ9r5hDPva1R9wVU+dgJYW75Ax1HXpewDju88=";
    };
  });
in

{
  xdg.configFile."kak/colors/off.kak".source = ./off.kak;

  programs.kakoune = {
    enable = true;
    package = kakoune;
    defaultEditor = true;

    extraConfig = ''
      set global startup_info_version 20241204

      eval %sh{${pkgs.kak-lsp}/bin/kak-lsp --kakoune -s $kak_session}
      hook global WinSetOption filetype=(go|zig|php|nix) %{
        lsp-enable-window
        lsp-inlay-diagnostics-enable window
        hook window BufWritePre .* lsp-formatting-sync
      }

      colorscheme off

      set global indentwidth 4
      set global ui_options terminal_set_title=false terminal_assistant=none terminal_enable_mouse=true
      set global autoinfo command

      add-highlighter global/ wrap
      add-highlighter global/ show-whitespaces -only-trailing -lf " " -indent ""

      def split-horizontal -params .. %{ with-option windowing_placement vertical new "%arg{@}" }
      def split-vertical -params .. %{ with-option windowing_placement horizontal new "%arg{@}" }

      complete-command split-horizontal command
      complete-command split-vertical command

      def assign-jumpclient %{ set global jumpclient %val{client} }
      def assign-toolsclient %{ set global toolsclient %val{client} }
      def assign-docsclient %{ set global docsclient %val{client} }

      def yank %{ exec "<a-|>xsel -bi<ret>" }
      def paste %{ set-register dquote %sh{ xsel -b } }
      def mkdir %{ nop %sh{ mkdir -p $(dirname $kak_buffile) } }

      hook global RawKey <c-mouse:press:right:.*> %{ try "exec gf" }
      hook global RawKey <c-scroll:[^-].*> %{ try "exec 3vk<c-i>" }
      hook global RawKey <c-scroll:-.*> %{ try "exec 3vj<c-o>" }

      hook global NormalKey "n|<a-n>" %{ exec -draft vv }

      # TODO: try to implement git update-diff
      hook global WinCreate ^[^*]+$ %{ }

      hook global WinSetOption filetype=(go) "set buffer indentwidth 0"
      hook global WinSetOption filetype=(html|json|nix|xml) "set buffer indentwidth 2"
      hook global WinSetOption filetype=(c|zig) "set buffer indentwidth 4"

      hook global WinSetOption filetype=git-commit %{
        set window autowrap_column 72
        set window autowrap_format_paragraph true
        autowrap-enable
      }
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

