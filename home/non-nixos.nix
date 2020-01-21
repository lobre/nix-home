{ config, pkgs, ... }:

{
  # To correct missing behaviors on non NixOS systems
  programs.bash.profileExtra = ''
      # Load nix if not already loaded
      if [ -z "$NIX_PROFILES" ]; then
          source $HOME/.nix-profile/etc/profile.d/nix.sh
      fi

      # Set xdg path that is normally set in NixOS with /etc/profile
      [[ ":$XDG_DATA_DIRS:" != *":$HOME/.nix-profile/share:"* ]] && export XDG_DATA_DIRS="$HOME/.nix-profile/share:$XDG_DATA_DIRS"
      [[ ":$XDG_CONFIG_DIRS:" != *":$HOME/.nix-profile/etc/xdg:"* ]] && export XDG_CONFIG_DIRS="$HOME/.nix-profile/etc/xdg:$XDG_CONFIG_DIRS"
  '';
}
