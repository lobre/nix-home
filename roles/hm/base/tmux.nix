{ pkgs, ... }:

{
  programs.tmux = {
    enable = true;

    clock24 = true; # 24h format
    disableConfirmationPrompt = true; # don't prompt when killing pane
    historyLimit = 10000;
    mouse = true;
    terminal = "tmux-256color";

    extraConfig = ''
      set -g base-index 1
      set -g status-keys emacs
      set -g mode-keys vi
      set -g escape-time 0

      # force to create non-login shells
      # otherwise ~/.bashrc not read and
      # tweaks for LD_PRELOAD not applied.
      set -g default-shell "/bin/bash"

      # terminal title
      set -g set-titles on
      set -g set-titles-string "#T"

      # status line
      set -g status-style 'bg=black fg=colour8'
      set -g status-left-length 30

      # prefix
      unbind C-b
      set -g prefix C-Space
      bind C-Space last-window

      # list sessions by last modified
      bind s choose-tree -sOtime

      # vim remaps
      bind ^ switch-client -l
      bind k select-pane -U
      bind j select-pane -D
      bind h select-pane -L
      bind l select-pane -R

      # resize
      bind -r H resize-pane -L 5
      bind -r J resize-pane -D 5
      bind -r K resize-pane -U 5
      bind -r L resize-pane -R 5

      # copy to clipboard
      set -s copy-command '${pkgs.xsel}/bin/xsel --input --clipboard'

      # better mouse selection
      bind -T copy-mode-vi MouseDragEnd1Pane send -X copy-pipe-no-clear
      bind -T copy-mode-vi MouseDown1Pane send -X clear-selection
    '';
  };
}
