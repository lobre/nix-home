{ config, pkgs, ... }:

let
  sessionVariables = {
    VISUAL = "vim";
    EDITOR = "vim";
    PAGER = "less";
  };

  shellAliases = {
    "ls" = "ls --color";
  };

  ansiBrightGreen = ''\[\033[1;32m\]'';
  ansiBrightBlue = ''\[\033[1;34m\]'';
  ansiYellow = ''\[\033[0;33m\]'';
  ansiReset = ''\[\033[0m\]'';

  initExtra = ''
    # Completion is not yet added my home manager
    # see https://github.com/nix-community/home-manager/issues/1464
    . ${pkgs.bash-completion}/share/bash-completion/bash_completion

    # Include unversioned files
    if [ -f "$HOME/.bashrc.local" ]; then
       . $HOME/.bashrc.local
    fi

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
  '';
in

{
  programs.bash = {
    enable = true;

    historySize = -1;
    historyFileSize = -1;

    sessionVariables = sessionVariables;
    shellAliases = shellAliases;
    initExtra = initExtra;
  };

  programs.readline = {
    enable = true;
    extraConfig = "set completion-ignore-case on";
  };

  programs.fzf = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;

    defaultCommand = "rg --files --no-ignore-vcs --hidden";
    defaultOptions = [ "--bind ctrl-n:down,ctrl-p:up" "--color=bg+:-1" ];

    fileWidgetCommand = config.programs.fzf.defaultCommand;
    changeDirWidgetCommand = config.programs.fzf.defaultCommand;
  };
}

