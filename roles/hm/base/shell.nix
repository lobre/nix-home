{ config, lib, pkgs, ... }:

{
  programs.bash = {
    enable = true;

    historySize = -1;
    historyFileSize = -1;

    sessionVariables = {
      PAGER = "less";
      LESS = "-R --mouse";
    };

    shellAliases = { "ls" = "ls --color"; };

    initExtra =
      let
        ansiBrightGreen = "\\[\\033[1;32m\\]";
        ansiBrightBlue = "\\[\\033[1;34m\\]";
        ansiYellow = "\\[\\033[0;33m\\]";
        ansiReset = "\\[\\033[0m\\]";
      in
      ''
        # Load git prompt utilities
        . ${config.programs.git.package}/share/git/contrib/completion/git-prompt.sh

        # Git prompt configs, see https://github.com/git/git/blob/master/contrib/completion/git-prompt.sh
        GIT_PS1_SHOWDIRTYSTATE=1
        GIT_PS1_SHOWSTASHSTATE=1
        GIT_PS1_SHOWUNTRACKEDFILES=1
        GIT_PS1_SHOWUPSTREAM="auto"
        GIT_PS1_STATESEPARATOR="|"

        PS1='${ansiBrightGreen}\h${ansiReset}:${ansiBrightBlue}\W${ansiYellow}$(__git_ps1 "(%s)")${ansiReset}\$ '

        # Set terminal title with xterm esc sequence
        case "$TERM" in
        xterm*)
            PS1="\[\e]0;\h: \W\a\]$PS1"
            ;;
        esac

        # Leave ctrl-s to bash history forward (instead of terminal freeze)
        stty -ixon

        # Include unversioned files
        if [ -f "$HOME/.bashrc.local" ]; then
           . $HOME/.bashrc.local
        fi
      '';
  };
}

