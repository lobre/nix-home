{ config, pkgs, ... }:

{
  programs.fzf = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;

    defaultCommand = "rg --files --no-ignore-vcs --hidden";
    defaultOptions = [ "--bind ctrl-t:down,ctrl-s:up" "--color=bg+:-1" ];

    fileWidgetCommand = config.programs.fzf.defaultCommand;
    changeDirWidgetCommand = config.programs.fzf.defaultCommand;
  };
}
