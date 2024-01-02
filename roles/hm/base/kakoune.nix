{ pkgs, ... }:

let
  kakoune = pkgs.kakoune-unwrapped.overrideAttrs (oldAttrs: {
    pname = "kakoune-unwrapped";
    version = "2023-12-04";
    patches = [ ];
    src = pkgs.fetchFromGitHub {
      owner = "mawww";
      repo = "kakoune";
      rev = "83fb65aef5729167b47c6ec22a57e5bd6ac5a9ae";
      sha256 = "sha256-yJ30mdMC36sbMkeIOkE5HypPz3PGPexsrWWdx1K6Bkk=";
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

