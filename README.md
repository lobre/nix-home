# nix-home

NixOS and Home Manager configurations.

![Screenshot](https://github.com/lobre/nix-config/raw/master/screenshot.png)

Make sure you have Home Manager installed: https://github.com/rycee/home-manager#installation.

Clone this repository.

Symlink NixOS configuration.

    sudo ln -sf $(pwd)/configuration.nix /etc/nixos/configuration.nix

Symlink home configuration.

    ln -sf $(pwd)/home.nix $HOME/.config/nixpkgs/home.nix
    ln -sf $(pwd)/home/config.nix $HOME/.config/nixpkgs/config.nix

Apply configurations.

    sudo nixos-rebuild switch
    home-manager switch -b bak

