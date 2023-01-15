{ config, pkgs, ... }:

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
    sshKeys = [
      "7405CC8962B56BC37069A825243B11236C4D2D3A" # mine (automatically loaded from YubiKey but needed on server)
      "ABBF7AEA51C125D874FD367816D6D0624116B381" # amersports
    ];
  };

  programs.ssh = {
    enable = true;

    extraOptionOverrides = { Include = "config.local"; };
  };
}
