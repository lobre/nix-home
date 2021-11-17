# Userspace configurations

## Repository and gopass store

After having installed NixOS, or if you want to install your Nix configurations on an Ubuntu system, you will need to clone this project.

```
git clone https://github.com/lobre/nix-home ~/lab/github.com/lobre/nix-home
```

Then, make sure to follow this [documentation page to import your GPG keys](gpg.md).

Now, you can clone your `gopass` store.

```
gopass clone https://github.com/<name>/<repo>.git
```

You will then be able to gather secrets from your store.

```
gopass show -n nix/secrets | envsubst '$HOME,$USER' > ~/lab/github.com/lobre/nix-home/secrets.nix
```

At this point, if you are on a NixOS system, you can test to re-apply your system configurations to see if everything still works as expected.

```
sudo ~/lab/github.com/lobre/nix-home/nix-switch.sh system
```

## Home Manager

For user configurations, we are using home manager. So we first need to install it.

### Installation

See the following page for the official documentation https://github.com/rycee/home-manager.

We first need to know which channel of Nix we are running. Check using `sudo nix-channel --list`. Then add the corresponding home manager channel and update.

```
# master / unstable
nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
# or specific channel
nix-channel --add https://github.com/nix-community/home-manager/archive/release-20.09.tar.gz home-manager

nix-channel --update
```

On NixOS you may need to log out and back in for the channel to become available. On non-NixOS you may have to export the following variable.

```
export NIX_PATH=$HOME/.nix-defexpr/channels${NIX_PATH:+:}$NIX_PATH
```

Then install home manager.

```
nix-shell '<home-manager>' -A install
```

Then, we need a home manager configuration file. If you are on an Ubuntu desktop or if you already have a machine configuration, you can skip next section.

### Create home configuration for new machine

If you are on a new NixOS machine, you will want to create and contribute a `home.nix` configuration file under your `machines` folder. You can take other machines as examples.

```
vim ~/lab/github.com/lobre/nix-home/machines/<my-machine>/home.nix
```

Make sure to commit and push that new file.

### Apply configurations

Simply use the custom script.

```
~/lab/github.com/lobre/nix-home/nix-switch.sh home
```

To note that this script will then become available in your path as simply `nix-switch`. So you will be able to launch it from anywhere.

At the end of the process, reboot the machine.
