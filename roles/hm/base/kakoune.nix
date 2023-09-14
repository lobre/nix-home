{ config, lib, pkgs, ... }:

{
  # colorscheme
  xdg.configFile."kak/colors/ansi.kak".source = ./ansi.kak;

  programs.kakoune = {
    enable = true;

    extraConfig = ''
      # hide changelog on startup
      set global startup_info_version 20230805

      # enable lsp
      eval %sh{${pkgs.kak-lsp}/bin/kak-lsp --kakoune -s $kak_session}

      # theme
      colorscheme ansi

      # default options
      set global indentwidth 4
      set global ui_options terminal_set_title=false terminal_assistant=none terminal_enable_mouse=true
      set global autoinfo command
      set global grepcmd 'grep --exclude=tags --exclude-dir=.git -RIHn'

      # find command
      define-command find -docstring "find files" -params 1 %{ edit %arg{1} }
      complete-command find shell-script-candidates %{ find * -type f -not -path '*/\.git/*' }

      # show matching characters, line numbers and wrap text
      add-highlighter global/ show-matching
      add-highlighter global/ number-lines -relative -separator ' '
      add-highlighter global/ wrap

      # update git diff in gutter
      hook global WinSetOption filetype=(?!grep).+ "git show-diff"
      hook global BufWritePost .* "git update-diff"
      hook global BufReload .* "git update-diff"

      hook global WinSetOption filetype=go %{
        set buffer indentwidth 0
        lsp-enable-window
        hook buffer BufWritePre .* lsp-formatting-sync
      }

      hook global WinSetOption filetype=zig %{
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

      # update system clipboard when c register modified
      hook global RegisterModified 'c' %{ nop %sh{
        printf %s "$kak_main_reg_c" | xsel --input --clipboard
      }}
    '';
  };

  # lsp configurations
  xdg.configFile."kak-lsp/kak-lsp.toml".text = with pkgs; ''
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

