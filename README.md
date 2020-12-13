# nix-home

NixOS and Home Manager configurations and instructions.

![Screenshot](screenshot.png)

## Table of contents

- Check [this page](docs/nixos-install.md) to know how to install NixOS with a ZFS filesystem.
- Check [this page](docs/home-manager.md) for using home-manager to apply user configurations.

## Non NixOS setup

If you want to apply the user configurations without having NixOS as the operating system, you will also have to follow the [home-manager documentation](docs/home-manager.md).

If you want to update your system, prefer the following command.

```
nix-channel --update; nix-env -iA nixpkgs.nix
```

### Xfce

If you are running Ubuntu, you should install Xfce.

```
# for oldest Ubuntu versions, use this PPA to have an up to date version.
sudo add-apt-repository ppa:xubuntu-dev/staging

sudo apt update
sudo apt install xfce4 xfce4-goodies
```

I also usually prefer using lightdm instead of gdm because it is simpler.

```
sudo apt-get install lightdm
sudo dpkg-reconfigure lightdm
```

#### Reset default properties

Home manager will make sure xfce properties are set as desired when applying the configurations. However, it will not delete any existing default ones. And they might sometimes collapse with the one I define. To avoid this problem, the first time you apply configurations, make sure to reset existing properties that could potentially interfere.

```
xfconf-query -c xfce4-keyboard-shortcuts --reset --recursive  --property "/commands/custom"
xfconf-query -c xfce4-keyboard-shortcuts --reset --recursive  --property "/xfwm4/custom"
xfconf-query -c xfce4-panel --reset --recursive  --property "/plugins"
```
