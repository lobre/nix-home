# nix-config

NixOS and Home Manager configurations.

![Screenshot](https://github.com/lobre/nix-config/raw/master/screenshot.png)

Make sure you have Home Manager installed: https://github.com/rycee/home-manager#installation.

Clone this repository in `$HOME/Lab/nix-config`.

Symlink NixOS configuration.

    sudo ln -sf $HOME/Lab/nix-config/configuration.nix /etc/nixos/configuration.nix

Symlink home configuration.

    sudo ln -sf $HOME/Lab/nix-config/home.nix $HOME/.config/nixpkgs/home.nix
    sudo ln -sf $HOME/Lab/nix-config/home/config.nix $HOME/.config/nixpkgs/config.nix

Apply configurations.

    sudo nixos-rebuild switch
    home-manager switch

