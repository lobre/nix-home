# Configure and install NixOS

These are the steps to execute after having prepared your partitions and filesystems.

## Clone this repo

All my configurations are stored in this GitHub repository. So we will have to download them before launching the installation process. Here is how I do it.

We need `git` installed and then, we clone the repository in `/mnt/etc/nixos`, where the installer expects them.

```
nix-env -iA nixos.git # or nix-env -iA nixpkgs.git
git clone https://github.com/lobre/nix-home /tmp/nix-home
```

## Secrets

Before installing, you need to gather secrets. As we are in a NixOS iso installer, we won’t be able to setup our GPG keys using the Yubikey because this needs some specific udev rules. So you need to find another way to retrieve the `secrets.nix` file. Make sure to have it at the root of the repository.

```
ls -l /tmp/nix-home/secrets.nix
```

The next step will depend if you want to install a new machine. If you don’t you can skip it.

## Create a new machine

For each machine, we have a corresponding folder in the repository under `/machines`. Choose a name for this new one and create a new folder with that name.

```
mkdir /tmp/nix-home/machines/<my-machine>
```

Then, you need to create a `configuration.nix` file in that new folder with the NixOS configuration. You can take example on another machine. Just make sure to match the machine hostname with the folder name that you have created.

```
vim /tmp/nix-home/machines/<my-machine>/configuration.nix
```

Then, you need to generate the hardware configuration that you should include in your `configuration.nix`.

```
nixos-generate-config --dir /tmp/nix-home/machines/<my-machine>
```

When this is done, you can commit and push your changes.

## Installation

Once ready, simply launch the installation command and reboot once it is finished.

Note that we decide to not set the root password as our configuration will create a user with root permissions.

```
env NIXOS_CONFIG=/tmp/nix-home/machines/<my-machine>/configuration.nix nixos-install --no-root-passwd
reboot
```
