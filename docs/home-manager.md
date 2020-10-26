# Home Manager

To install user configurations, we are using home-manager. So we first need to install it. In this section, we work on the assumption that this `nix-home` repo is cloned under `~/Lab/nix-home`.

## Installation of home-manager

See the following page for the official documentation https://github.com/rycee/home-manager.

We first need to know which channel of Nix we are running. Check using `sudo nix-channel --list`. Then add the corresponding home-manager channel and update.

```
# master / unstable
nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
# or specific channel
nix-channel --add https://github.com/nix-community/home-manager/archive/release-20.03.tar.gz home-manager

nix-channel --update
```

Then install home-manager.

```
nix-shell '<home-manager>' -A install
```

## Prepare and apply the configurations

Once installed, home-manager will have created the initial configuration under `~/.config/nixpkgs/home.nix`. Go edit this file to include our user configurations. The file will look like something like this.

```
{ config, pkgs, ... }:

{
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  imports = [
    /home/lobre/Lab/nix-home/home/config.nix
    /home/lobre/Lab/nix-home/home/term.nix
    /home/lobre/Lab/nix-home/home/gui.nix
  ];

  home.stateVersion = "20.03";
}
```

You can finally apply the configuration.

```
home-manager switch -b back
```

At the end of the process, reboot the machine.

If you want to add custom wallpapers, download them into `~/Pictures/Wallpapers`.
