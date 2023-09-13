{ config, pkgs, ... }:

{
  programs.tmux = {
    enable = true;
    terminal = "tmux-256color";
    keyMode = "vi";
    customPaneNavigationAndResize = true; # remap to use hjkl to switch windows
    disableConfirmationPrompt = true; # don't prompt when killing pane
    historyLimit = 10000;
    clock24 = true; # 24h format

    extraConfig = ''
      set -g mouse on
      set -g base-index 1
      set -g status-keys emacs

      # prefix
      unbind C-b
      set-option -g prefix C-a
      bind-key C-a send-prefix

      # terminal title
      set -g set-titles on
      set -g set-titles-string "#T"

      # status line
      set -g status-style 'bg=black fg=colour8'
      set -g status-left-length 30

      # only let tmux wait 20ms for escape
      set -g escape-time 20

      # copy to clipboard
      set -s copy-command '${pkgs.xsel}/bin/xsel --input --clipboard'

      # better mouse selection
      bind -T copy-mode-vi MouseDragEnd1Pane send -X copy-pipe-no-clear
      bind -T copy-mode-vi MouseDown1Pane send -X clear-selection
    '';
  };
}
