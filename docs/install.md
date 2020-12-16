# Configure and install NixOS

These are the steps to execute after having prepared your partitions and filesystems.

## Clone this repo

All my configurations are stored in this GitHub repository. So we will have to download them before launching the installation process. Here is how I do it.

We need `git` installed and then, we clone the repository in `/mnt/etc/nixos`, where the installer expects them.

```
nix-env -iA nixos.git # or nix-env -iA nixpkgs.git
git clone https://github.com/lobre/nix-home /mnt/etc/nixos
```

## Create configuration.nix

In the repository, `configuration.nix` and `hardware-configuration.nix` are excluded in the `.gitignore`. So these files don’t exist yet.

In this step, we will create `configuration.nix` starting from the skeleton `configuration.skel.nix` available at the root of the repository.

```
cp /mnt/etc/nixos/{configuration.skel,configuration}.nix
```

Then, you can start to edit this file, uncomment and fill in the missing configurations.

## Generate hardware-configuration.nix

NixOS installer is able to detect our configuration and generate a `hardware-configuration.nix` for us.

Use the following command to execute the generation. Note that as `configuration.nix` already exists, it won’t get overriden.

```
nixos-generate-config --root /mnt
```

You can throw a look at the generated hardware configuration in `/mnt/etc/nixos/hardware-configuration.nix`.

## Installation

Once ready, simply launch the installation command and reboot once it is finished.

Note that we decide to not set the root password as our configuration will create a user with root permissions.

```
nixos-install --no-root-passwd
reboot
```
