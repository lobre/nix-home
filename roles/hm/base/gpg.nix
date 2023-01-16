{ config, pkgs, ... }:

{
  home.packages = with pkgs; [ paperkey ];

  programs.gpg = {
    enable = true;
    settings.no-autostart = true; # don’t autostart gpg-agent if not started
  };

  # force gpg agent for ssh especially for gpg agent forwarding
  home.sessionVariablesExtra = ''
    if [[ -z "$SSH_AUTH_SOCK" ]]; then
      export SSH_AUTH_SOCK="$(${pkgs.gpgPkg}/bin/gpgconf --list-dirs agent-ssh-socket)"
    fi
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
      "ABBF7AEA51C125D874FD367816D6D0624116B381" # amersports
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
