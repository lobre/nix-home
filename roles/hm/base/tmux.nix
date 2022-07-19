{ config, pkgs, ... }:

let
  tmuxSession = pkgs.writeScriptBin "tmux-session" ''
    #!${pkgs.stdenv.shell}

    path=$1

    if [[ -z "$path" ]]; then
        echo "missing path argument"; exit 1
    fi

    name=$(basename "$path" | tr . _)
    running=$(pgrep --exact "tmux: server")

    if [[ -z $running ]]; then
        tmux new-session -s $name -c $path; exit 0
    fi

    if ! tmux has-session -t=$name 2>/dev/null; then
        tmux new-session -ds $name -c $path
    fi

    if [[ -z "$TMUX" ]]; then
        tmux attach -t $name
    else
        tmux switch-client -t $name
    fi
  '';
in

{
  home.packages = [ tmuxSession ];

  programs.tmux = {
    enable = true;
    terminal = "screen-256color";
    keyMode = "vi";
    customPaneNavigationAndResize = true; # remap to use hjkl to switch windows
    disableConfirmationPrompt = true; # don't prompt when killing pane
    historyLimit = 5000;
    clock24 = true; # 24h format

    extraConfig = ''
      set -g mouse on

      # session name stripped otherwise
      set -g status-left-length 50

      bind v copy-mode
      bind P paste-buffer

      bind -T copy-mode-vi Escape send-keys -X cancel
      bind -T copy-mode-vi v send-keys -X begin-selection
      bind -T copy-mode-vi y send-keys -X copy-pipe-and-cancel '${pkgs.xclip}/bin/xclip -in -selection clipboard'

      bind -T copy-mode-vi MouseDragEnd1Pane send -X copy-pipe-no-clear
      bind -T copy-mode-vi MouseDown1Pane send -X clear-selection
    '';
  };
}
