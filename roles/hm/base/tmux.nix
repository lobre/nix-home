{ config, pkgs, ... }:

{
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

      # split above and left as in vim
      bind-key '"' split-window -vb
      bind-key % split-window -hb

      # session name was stripped as too small
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
