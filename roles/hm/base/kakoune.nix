{ pkgs, ... }:

let
  kakoune = pkgs.kakoune-unwrapped.overrideAttrs (oldAttrs: {
    pname = "kakoune-unwrapped";
    version = "2024-02-05";
    patches = [ ];
    src = pkgs.fetchFromGitHub {
      owner = "mawww";
      repo = "kakoune";
      rev = "c97add7f5a181f459b2f349069507093be2bc738";
      sha256 = "sha256-dpoE2anoN504kLtcTLfZjRj6pvdzjZbn11P7iA4MZ4Q=";
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

      define-command split -params .. %{ with-option windowing_placement vertical new "%arg{@}" }
      complete-command split command
      define-command vsplit -params .. %{ with-option windowing_placement horizontal new "%arg{@}" }
      complete-command vsplit command

      map global normal <ret> '_|sh<ret>'

      hook global WinSetOption filetype=go "set buffer indentwidth 0"
      hook global WinSetOption filetype=(html|json|nix|xml) "set buffer indentwidth 2"
      hook global WinSetOption filetype=(c|zig) "set buffer indentwidth 4"

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

