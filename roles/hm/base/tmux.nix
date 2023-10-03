{ pkgs, ... }:

{
  programs.tmux = {
    enable = true;

    clock24 = true; # 24h format
    customPaneNavigationAndResize = true; # remap to use hjkl to switch windows
    disableConfirmationPrompt = true; # don't prompt when killing pane
    historyLimit = 10000;
    keyMode = "vi";
    mouse = true;
    terminal = "tmux-256color";

    extraConfig = ''
      set -g base-index 1
      set -g status-keys emacs

      # prefix
      unbind C-b
      set -g prefix C-Space
      bind C-Space last-window

      # terminal title
      set -g set-titles on
      set -g set-titles-string "#T"

      # status line
      set -g status-style 'bg=black fg=colour8'
      set -g status-left-length 30

      # only let tmux wait 20ms for escape
      set -g escape-time 20

      # list sessions by last modified
      bind -T prefix s choose-tree -sOtime

      # go to last session
      bind-key -T prefix \# switch-client -l

      # copy to clipboard
      set -s copy-command '${pkgs.xsel}/bin/xsel --input --clipboard'

      # better mouse selection
      bind -T copy-mode-vi MouseDragEnd1Pane send -X copy-pipe-no-clear
      bind -T copy-mode-vi MouseDown1Pane send -X clear-selection
    '';
  };
}
