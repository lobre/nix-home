# Home Manager

To install user configurations, we are using home-manager. So we first need to install it. In this section, we work on the assumption that this `nix-home` repo is cloned under `~/lab/github.com/lobre/nix-home`.

## Installation of home-manager

See the following page for the official documentation https://github.com/rycee/home-manager.

We first need to know which channel of Nix we are running. Check using `sudo nix-channel --list`. Then add the corresponding home-manager channel and update.

```
# master / unstable
nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
# or specific channel
nix-channel --add https://github.com/nix-community/home-manager/archive/release-20.09.tar.gz home-manager

nix-channel --update
```

Then install home-manager. You may need to logout and back in for the channel to become available.

```
nix-shell '<home-manager>' -A install
```

## Prepare and apply the configurations

We need to create an initial configuration file `home.nix` that will serve as the entrypoint to home-manager. We can start from `home.skel.nix`.

```
cp home.skel.nix home.nix
```

Then, you can start to edit this file, uncomment and fill in the missing configurations.

You can finally apply the configuration. For that, use the following script that will tell home-manager where to find our configuration file.

```
./nix-switch.sh home
```

At the end of the process, reboot the machine.
