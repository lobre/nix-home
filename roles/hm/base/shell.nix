{ config, pkgs, ... }:

let
  sessionVariables = {
    VISUAL = "vim";
    EDITOR = "vim";
    PAGER = "less";
  };

  shellAliases = {
    "ls"     = "ls --color";
    "ll"     = "ls -lh";
    "extip"  = "wget http://ipinfo.io/ip -qO -";
  };

  initExtra = ''
    # Completion is not yet added my home manager
    # see https://github.com/nix-community/home-manager/issues/1464
    . ${pkgs.bash-completion}/share/bash-completion/bash_completion

    # Include unversioned files
    if [ -f "$HOME/.bashrc.local" ]; then
       . $HOME/.bashrc.local
    fi

    # Simple prompt with git branch and without user
    git_branch() { git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/'; }
    PS1="\[\033[01;32m\]\[\033[0m\033[0;32m\]\[\033[01;32m\]\h\[\033[00m\]:\[\033[01;34m\]\W\[\033[00m\]\[\033[33m\]\$(git_branch)\[\033[00m\]\$ "
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

