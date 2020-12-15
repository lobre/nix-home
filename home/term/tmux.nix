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
    keyMode = "vi";
    customPaneNavigationAndResize = true; # remap to use hjkl to switch windows
    historyLimit = 5000;
    clock24 = true;
  };
}
