{ pkgs, ... }:

{
  programs.tmux = {
    enable = true;

    sensibleOnTop = false; # do not automatically execute this plugin
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
      set -g status-left ""
      set -g status-right " [#{session_name}]"
      set -g status-right-length 30
      set -g status-justify right
      set -g status-position top
      set -g status-style "bg=default fg=colour8"

      # prefix
      unbind C-b
      set -g prefix C-Space

      # list sessions zoomed and by last modified
      bind s choose-tree -Z -sOtime

      # copy to clipboard
      set -s copy-command '${pkgs.xsel}/bin/xsel --input --clipboard'

      # better mouse selection
      bind -T copy-mode-vi MouseDragEnd1Pane send -X copy-pipe-no-clear
      bind -T copy-mode-vi MouseDown1Pane send -X clear-selection
    '';
  };
}
