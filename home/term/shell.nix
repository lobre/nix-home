{ config, pkgs, ... }:

let
  sessionVariables = {
    LAB = "$HOME/Lab";
    VISUAL = "vim";
    EDITOR = "vim";
  };

  shellAliases = {
    "ls"     = "ls --color";
    "ll"     = "ls -lh";
    ".."     = "cd ..";
    "..."    = "cd ../..";
    "extip"  = "wget http://ipinfo.io/ip -qO -";
    "copy"   = "${pkgs.xclip}/bin/xclip -selection clipboard";
    "rg"     = "rg --no-ignore-vcs --smart-case";
  };

  initExtra = ''
    # Include unversioned files
    if [ -f "$HOME/.bashrc.local" ]; then
       . $HOME/.bashrc.local
    fi

    # Simple prompt with git branch and without user
    git_branch() { git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/'; }
    PS1="\[\033[01;32m\]\[\033[0m\033[0;32m\]\[\033[01;32m\]\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\[\033[33m\]\$(git_branch)\[\033[00m\]\$ "
  '';
in

{
  programs.bash = {
    enable = true;

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

