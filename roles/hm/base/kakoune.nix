{ pkgs, ... }:

let
  kakoune = pkgs.kakoune-unwrapped.overrideAttrs (oldAttrs: {
    pname = "kakoune-unwrapped";
    version = "2023-12-04";
    src = pkgs.fetchFromGitHub {
      owner = "mawww";
      repo = "kakoune";
      rev = "7f49395cf931b2af8a75ffb5319a8aa8c395ed8d";
      sha256 = "sha256-4m8aFsS/842J4fdnZQ/Sq/9OY7xOwr+H1TM2kllPgA0=";
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
      # hide changelog on startup
      set global startup_info_version 20241204

      # enable lsp
      eval %sh{${pkgs.kak-lsp}/bin/kak-lsp --kakoune -s $kak_session}
      hook global WinSetOption filetype=(go|zig|php|nix) %{
        lsp-enable-window
        hook buffer BufWritePre .* lsp-formatting-sync
      }

      # default options
      colorscheme off
      set global indentwidth 4
      set global ui_options terminal_set_title=false terminal_assistant=none terminal_enable_mouse=true
      set global autoinfo command

      # highlighters
      add-highlighter global/ show-matching
      add-highlighter global/ wrap

      # update git diff in gutter
      hook global WinCreate .* %{ evaluate-commands %sh{ [ $kak_buffile != $kak_bufname ] && echo "git show-diff" }}
      hook global BufWritePost .* "git update-diff"
      hook global BufReload .* "git update-diff"

      # indentation
      hook global WinSetOption filetype=go "set buffer indentwidth 0"
      hook global WinSetOption filetype=nix "set buffer indentwidth 2"
      hook global WinSetOption filetype=zig "set buffer indentwidth 4"
      hook global WinSetOption filetype=(html|json|xml) "set buffer indentwidth 2"

      hook global WinSetOption filetype=git-commit %{
        set-option window autowrap_column 72
        set-option window autowrap_format_paragraph true
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

