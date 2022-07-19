{ config, pkgs, ... }:

let
  tmuxSession = pkgs.writeScriptBin "tmux-session" ''
    #!${pkgs.stdenv.shell}

    if [[ $# -eq 1 ]]; then
        selected=$1
    else
        selected=$(fd . ~ --type d | fzf)
    fi

    if [[ -z $selected ]]; then
        exit 0
    fi

    selected_name=$(basename "$selected" | tr . _)
    tmux_running=$(pgrep --exact "tmux: server")

    if [[ -z $tmux_running ]]; then
        tmux new-session -s "$selected_name" -c "$selected"
        exit 0
    fi

    if ! tmux has-session -t="$selected_name" 2>/dev/null; then
        tmux new-session -ds "$selected_name" -c "$selected"
    fi

    if [[ -z $TMUX ]]; then
        tmux attach -t "$selected_name"
    else
        tmux switch-client -t "$selected_name"
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

      bind t run-shell "tmux new-window ${tmuxSession}/bin/tmux-session"

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
