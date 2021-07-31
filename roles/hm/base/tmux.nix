{ config, pkgs, ... }:

{
  programs.tmux = {
    enable = true;
    terminal = "screen-256color";
    keyMode = "vi";
    customPaneNavigationAndResize = true; # remap to use hjkl to switch windows
    disableConfirmationPrompt = true; # don't prompt when killing pane
    historyLimit = 5000;
    clock24 = true;

    extraConfig = ''
      set -g mouse on
      bind -T copy-mode-vi Enter send -X copy-pipe-and-cancel '${pkgs.xclip}/bin/xclip -in -selection clipboard'
    '';
  };
}
