{ config, pkgs, ... }:

{
  # colorscheme
  xdg.configFile."kak/colors/ansi.kak".source = ./ansi.kak;

  programs.kakoune = {
    enable = true;

    config = {
      colorScheme = "ansi";
      indentWidth = 4;
      showMatching = true;

      ui = {
        assistant = "none";
        enableMouse = true;
        setTitle = true;
      };

      hooks = [
        {
          name = "BufSetOption";
          option = "filetype=go";
          commands = ''
            set-option buffer indentwidth 0
            set-option buffer formatcmd '${pkgs.gotools}/bin/goimports | ${config.programs.go.package}/bin/gofmt'
            hook buffer BufWritePre .* format
          '';
        }
        {
          name = "BufSetOption";
          option = "filetype=zig";
          commands = ''
            set-option buffer indentwidth 4
            set-option buffer formatcmd '${pkgs.zig}/bin/zig fmt --stdin'
            hook buffer BufWritePre .* format
          '';
        }
        {
          name = "BufSetOption";
          option = "filetype=elm";
          commands = ''
            set-option buffer indentwidth 4
            set-option buffer formatcmd '${pkgs.elmPackages.elm-format}/bin/elm-format --stdin'
            hook buffer BufWritePre .* format
          '';
        }
        {
          name = "BufSetOption";
          option = "filetype=nix";
          commands = ''
            set-option buffer indentwidth 2
            set-option buffer formatcmd ${pkgs.nixfmt}/bin/nixfmt
            hook buffer BufWritePre .* format
          '';
        }
        {
          name = "BufSetOption";
          option = "filetype=html";
          commands = ''
            set-option buffer indentwidth 2
          '';
        }
        {
          name = "BufSetOption";
          option = "filetype=json";
          commands = ''
            set-option buffer indentwidth 2
          '';
        }
      ];
    };

    extraConfig = ''
      set-option global startup_info_version 20211108

      define-command find -params 1 -docstring 'find a file' -shell-script-candidates %{
        git ls-files --recurse-submodules
      } %{
        edit %arg{1}
      }

      define-command line-numbers-toggle -docstring 'toggle line numbers' %{
        try %{
          add-highlighter global/line-numbers number-lines -separator ' ' -hlcursor
          echo -markup "{Information}line numbers enabled"
        } catch %{
          remove-highlighter global/line-numbers
          echo -markup "{Information}line numbers disabled"
        }
      }

      define-command whitespaces-toggle -docstring 'toggle whitespaces' %{
        try %{
          add-highlighter window/whitespaces show-whitespaces -tab '→' -spc '·' -nbsp '␣' -lf '↲'
          echo -markup "{Information}whitespaces enabled"
        } catch %{
          remove-highlighter window/whitespaces
          echo -markup "{Information}whitespaces disabled"
        }
      }

      define-command wrap-toggle -docstring 'toggle soft wrap' %{
        try %{
          add-highlighter global/wrap wrap
          echo -markup "{Information}soft wrap enabled"
        } catch %{
          remove-highlighter global/wrap
          echo -markup "{Information}soft wrap disabled"
        }
      }

      # enable wrapping
      wrap-toggle
    '';
  };
}

