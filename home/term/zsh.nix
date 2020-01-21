{ config, pkgs, ... }:

{
  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    enableCompletion = true;
    autocd = true;

    localVariables = {
      COMPLETION_WAITING_DOTS = "true";
    };

    sessionVariables = config.programs.bash.sessionVariables;
    shellAliases = config.programs.bash.shellAliases;
    initExtra = config.programs.bash.initExtra + ''
      bindkey -M emacs '^P' history-substring-search-up
      bindkey -M emacs '^N' history-substring-search-down
    '';

    oh-my-zsh = {
      enable = true;
      plugins = [ "git" "sudo" "history-substring-search" ];
      theme = "fishy";
    };

  };
}
