{ config, pkgs, ... }:

{
  # To correct missing behaviors on non NixOS systems
  programs.bash.profileExtra = ''
      # Load nix if not already loaded
      [[ ":$PATH:" != *":$HOME/.nix-profile/bin:"* ]] && source $HOME/.nix-profile/etc/profile.d/nix.sh

      # Add bin in PATH if not already existing
      [[ ":$PATH:" != *":$HOME/bin:"* ]] && export PATH="$PATH:$HOME/bin"

      # Set xdg path that is normally set in NixOS with /etc/profile
      [[ ":$XDG_DATA_DIRS:" != *":$HOME/.nix-profile/share:"* ]] && export XDG_DATA_DIRS="$HOME/.nix-profile/share:$XDG_DATA_DIRS"
      [[ ":$XDG_CONFIG_DIRS:" != *":$HOME/.nix-profile/etc/xdg:"* ]] && export XDG_CONFIG_DIRS="$HOME/.nix-profile/etc/xdg:$XDG_CONFIG_DIRS"
  '';
}
