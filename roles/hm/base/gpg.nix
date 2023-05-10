{ config, pkgs, ... }:

{
  home.packages = with pkgs; [ paperkey ];

  programs.gpg = {
    enable = true;
    settings.no-autostart = true; # don’t autostart gpg-agent if not started
  };

  # force gpg agent for ssh especially for gpg agent forwarding over ssh
  home.sessionVariablesExtra = ''
    export SSH_AUTH_SOCK="$(${config.programs.gpg.package}/bin/gpgconf --list-dirs agent-ssh-socket)"
  '';

  services.gpg-agent = {
    enable = true;
    enableSshSupport = true;
    enableExtraSocket = true; # useful for agent forwarding

    # List of keys exposed to the agent.
    # This should in the keygrip format. Find out using:
    # gpg --list-secret-keys --with-keygrip
    # Note that YubiKey keys are automatically loaded.
    sshKeys = [
      "3345B9FEA3695058E23F58154E7B544A584CFE3E" # amersports
    ];
  };

  programs.ssh = {
    enable = true;

    # forward gpg agent
    matchBlocks = {
      "lobre@lobre.io" = {
        remoteForwards = [
          {
            bind.address = "/run/user/1000/gnupg/S.gpg-agent";
            host.address = "/\${XDG_RUNTIME_DIR}/gnupg/S.gpg-agent.extra";
          }
          {
            bind.address = "/run/user/1000/gnupg/S.gpg-agent.ssh";
            host.address = "/\${XDG_RUNTIME_DIR}/gnupg/S.gpg-agent.ssh";
          }
        ];
      };
    };

    extraConfig = "Include config.local";
  };
}
