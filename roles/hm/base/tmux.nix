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

      # terminal title
      set -g set-titles on
      set -g set-titles-string "tmux | #W"

      # status line
      set -g status-position top
      set -g status-style bg=default
      set -g status-justify centre
      set -g status-left ""
      set -g window-status-format "  #W  "
      set -g window-status-current-format "#[fg=green,bold bg=black]▶#[fg=green bg=black] #W #[fg=green,bold bg=black]◀"
      set -g status-right "#[fg=brightblack]working on #[fg=blue,bold]#S"

      # toggle status line
      bind Enter set -g status

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
