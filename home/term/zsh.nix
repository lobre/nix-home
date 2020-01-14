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

    oh-my-zsh = {
      enable = true;
      plugins = [ "git" "sudo" ];
      theme = "fishy";
    };

  };
}
