{ config, pkgs, secrets, ... }:

{
  home.packages = with pkgs; [ paperkey ];

  programs.gpg.enable = true;

  services.gpg-agent = {
    enable = true;
    enableSshSupport = true;

    # List of keys exposed to the agent.
    # This should in the keygrip format. Find out using:
    # gpg --list-secret-keys --with-keygrip
    # Note that YubiKey keys are automatically loaded.
    sshKeys = secrets.ssh.keygrip;
  };

  programs.ssh = {
    enable = true;

    extraOptionOverrides = {
      Include = "config.local";
    };
  };
}
