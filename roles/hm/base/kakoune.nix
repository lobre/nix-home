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
        hook buffer BufWritePre .* lsp-formatting-sync
      }

      colorscheme off
      set global indentwidth 4
      set global ui_options terminal_set_title=false terminal_assistant=none terminal_enable_mouse=true
      set global autoinfo command
      add-highlighter global/ wrap
      add-highlighter global/ show-whitespaces -only-trailing -lf " " -indent ""

      define-command split -params .. %{ with-option windowing_placement vertical new "%arg{@}" }
      define-command vsplit -params .. %{ with-option windowing_placement horizontal new "%arg{@}" }

      complete-command split command
      complete-command vsplit command

      define-command yank %{ exec "<a-|>xsel -bi<ret>" }
      define-command paste %{ set-register dquote %sh{ xsel -b } }

      define-command mkdir %{ nop %sh{ mkdir -p $(dirname $kak_buffile) } }

      map global normal <ret> ':repl-send-text %sh{ echo $kak_selection; printf \\n }<ret>'

      hook global WinSetOption filetype=go "set buffer indentwidth 0"
      hook global WinSetOption filetype=(html|json|nix|xml) "set buffer indentwidth 2"
      hook global WinSetOption filetype=(c|zig) "set buffer indentwidth 4"

      # try to implement git update-diff
      hook global WinCreate ^[^*]+$ %{ }

      hook global WinSetOption filetype=git-commit %{
        set-option window autowrap_column 72
        set-option window autowrap_format_paragraph true
        autowrap-enable
      }

      evaluate-commands %sh{ [ -f $kak_config/local.kak ] && echo "source $kak_config/local.kak" }
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

