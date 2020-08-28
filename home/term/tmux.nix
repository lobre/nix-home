{ config, pkgs, ... }:

let
  multiSSH = pkgs.writeScriptBin "multi-ssh" ''
    #!${pkgs.stdenv.shell}
    # 
    # ssh-multi.sh - a script to ssh multiple servers over multiple tmux panes
    # usage: type tmux then from inside tmux type ssh-multi.sh HOST1 HOST2 ... HOSTN

    function error() {
      echo "$@" >&2
      exit -1
    }

    start() {
        local hosts=( $HOSTS )

        first="ssh ''\${hosts[0]}"
        unset hosts[0]

        for i in "''\${hosts[@]}"; do
            ${config.programs.tmux.package}/bin/tmux split-window -h  "ssh $i"
            ${config.programs.tmux.package}/bin/tmux select-layout tiled > /dev/null
        done

        ${config.programs.tmux.package}/bin/tmux select-pane -t 0
        ${config.programs.tmux.package}/bin/tmux set-window-option synchronize-panes on > /dev/null

        $first
    }

    [ $# -lt 1 ] && error "usage: $0 HOST1 HOST2 ..."

    HOSTS=$@

    ${config.programs.tmux.package}/bin/tmux refresh -S 2>/dev/null && start "$@" || error "please run from inside tmux"
  '';
in

{
  home.packages = [ multiSSH ];

  programs.tmux = {
    enable = true;
    terminal = "screen-256color";
    shortcut = "space";
    resizeAmount = 5;
    keyMode = "vi";
    historyLimit = 5000;
    escapeTime = 1;
    customPaneNavigationAndResize = false;
    clock24 = true;
    baseIndex = 1;
    
    # to manage sessions
    tmuxp.enable = true;

    extraConfig = ''
      setw -g pane-base-index 1

      # highlight window when it has new activity
      setw -g monitor-activity off
      set -g visual-activity off

      # enable ctrl + arrow moves
      set -g xterm-keys on

      # don't rename windows automatically
      set-option -g allow-rename off
      set-window-option -g automatic-rename off

      # mouse
      set -g mouse off
      bind m set -g mouse \; display "Mouse mode changed"

      # kill current pane
      bind q kill-pane

      # Default pane switching
      bind h select-pane -L
      bind j select-pane -D
      bind k select-pane -U
      bind l select-pane -R

      # Pane resize
      bind -r H resize-pane -L 5
      bind -r J resize-pane -D 5
      bind -r K resize-pane -U 5
      bind -r L resize-pane -R 5

      # window splitting
      bind v split-window -h
      bind s split-window -v

      # toggle synchronize mode
      bind a set-window-option synchronize-panes \; display "Synchronize mode changed"

      # restore ctrl + L to clear screen with prefix + Ctrl + L
      bind C-l send-keys 'C-l'

      bind w new-window
      bind W choose-window

      unbind [
      bind c copy-mode

      unbind P
      bind P paste-buffer

      bind -T copy-mode-vi v send -X begin-selection

      # Enter copy in clipboard
      bind -T copy-mode-vi Enter send -X copy-pipe-and-cancel 'xclip -in -selection clipboard'
      bind -T copy-mode-vi y send -X copy-pipe-and-cancel 'xclip -in -selection clipboard'

      bind -T copy-mode-vi C-v send -X rectangle-toggle
      bind -T copy-mode-vi Escape send -X cancel

      bind -T copy-mode-vi d send -X halfpage-down
      bind -T copy-mode-vi u send -X halfpage-up

      bind -T copy-mode-vi h send -X cursor-left
      bind -T copy-mode-vi j send -X cursor-down
      bind -T copy-mode-vi k send -X cursor-up
      bind -T copy-mode-vi l send -X cursor-right
      bind -T copy-mode-vi H send -X top-line
      bind -T copy-mode-vi L send -X bottom-line
      bind -T copy-mode-vi J send -X scroll-down
      bind -T copy-mode-vi K send -X scroll-up

      # Prevent garbage characters everywhere after copy
      set-option -s set-clipboard off

      # The status bar itself.
      set -g status-justify centre
      set -g status-left-length 40
      set -g status-left "#[fg=green]#H"
      set -g status-right "#[fg=blue]%d %b %R"

      # default statusbar colors
      set -g status-fg white
      set -g status-bg default
    '';
  };
}
