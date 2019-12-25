# nix-config

NixOS and Home Manager configurations.

Clone this repository in `.config/nixpkgs`.

    mv $HOME/.config/nixpkgs $HOME/.config/nixpkgs.old
    git clone https://github.com/lobre/nix-config.git $HOME/.config/nixpkgs

Then link the main NixOS configuration file.

    sudo ln -sf $HOME/.config/nixpkgs/configuration.nix /etc/nixos/configuration.nix

Make sure you have Home Manager installed.

https://github.com/rycee/home-manager#installation

Apply configurations.

    sudo nixos-rebuild switch
    home-manager switch

## Fresh NixOS install

If you have no userspace yet, just get the `configuration.nix` file from this repo and place it under `/etc/nixos/configuration.nix`. Then do a `nixos-rebuild switch`.


