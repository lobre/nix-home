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

    initExtra = config.programs.bash.initExtra + ''
    compdef shally=ssh
    '';

    sessionVariables = config.programs.bash.sessionVariables;
    shellAliases = config.programs.bash.shellAliases;

    oh-my-zsh = {
      enable = true;
      plugins = [ "git" "sudo" ];
      theme = "fishy";
    };

  };
}
