# nix-home

NixOS and Home Manager configurations.

![Screenshot](https://github.com/lobre/nix-config/raw/master/screenshot.png)

## NixOS

Here is the procedure to install NixOS on a physical or virtual machine.

The first step is to download a NixOS iso Graphical image from https://nixos.org/nixos/download.html.
Then you can insert it in your machine and boot. You will land on a simple desktop where you will be able to prepare and launch the installation.

### Change the keyboard layout

For convenience, start by changing the keyboard layout.

    setxkbmap fr -variant bepo

### Partitioning

The NixOS installer does not manage partitioning. That's why it is required to do it beforehand.
The corresponding manual page is at https://nixos.org/nixos/manual/#sec-installation-partitioning.

We will consider the UEFI method as it is more recent.

That means we will need 3 partitions at minimum (a partition number is added here as example):
- **boot** (sda1): if you already have a system installed, it might already exists.
- **root** (sda2): it it where the main system will land.
- **swap** (sda3): will be used for additional memory on disk.

Make sure the boot partition is around 512MiB and has the ESP and boot flags. I usually create a swap partition of 8GiB.

Then we need to mount the corresponding partitions as follows.

    sudo mount /dev/sda2 /mnt
    sudo mkdir /mnt/boot
    sudo mount /dev/sda1 /mnt/boot

We also need to enable the swap.

    sudo swapon /dev/sda3

### Configuration of the installation

Before launching the installation process, we can configure NixOS in advance. First, generate an initial configuration with the following command.

    sudo nixos-generate-config --root /mnt

Then, be sure to install `git`, clone this repository and copy system configurations in `/mnt/etc/nixos`.

    nix-env -iA nixos.git
    git clone https://github.com/lobre/nix-home
    sudo cp -r nix-home/system* /mnt/etc/nixos/

To finish the preparation, go edit the main `configuration.nix` file and include the desired system configurations. The file should look like something like this.

    { config, pkgs, ... }:

    {
      imports = [
        ./hardware-configuration.nix
        ./system.nix
        ./system/hardware.nix
        ./system/x11.nix
        ./system/users.nix
      ];

      system.stateVersion = "20.03";
    }

The last step you have to do is to generate a password for the `lobre` user.

    mkdir /mnt/etc/nixos/secrets
    mkpasswd -m sha-512 > /mnt/etc/nixos/secrets/lobre-password.txt

You are now ready to start the installation.

### Installation

Simply launch the installation command and reboot once it is finished.

    sudo nixos-install
    sudo reboot

### After install

Now that the system is installed and booted, you will want to re-clone this project in a user space directory and adjust the import paths in `/etc/nixos/configuration.nix`.

    mkdir ~/Lab
    git clone https://github.com/lobre/nix-home ~/Lab/nix-home
    sudo vim /etc/nixos/configuration.nix # make the modifications
    sudo rm -rf /etc/nixos/system*

You are now ready to use the system. You might also want to install the user configuration using home-manager. See the next section.

## Home Manager

To install user configuration, we are using home-manager. So we first need to install it. In this section, we work on the assumption that this `nix-home` repo is cloned under `~/Lab/nix-home`.

### Installation of home-manager

See the following page for the official documentation https://github.com/rycee/home-manager.

We first need to know which channel of Nix we are running. Check using `sudo nix-channel --list`. Then add the corresponding home-manager channel and update.

    # master / unstable
    nix-channel --add https://github.com/rycee/home-manager/archive/master.tar.gz home-manager
    # or specific channel
    nix-channel --add https://github.com/rycee/home-manager/archive/release-19.09.tar.gz home-manager

    nix-channel --update

Then install home-manager.

    nix-shell '<home-manager>' -A install

### Prepare and apply the configurations

Once installed, home-manager will have created the initial configuration under `~/.config/nixpkgs/home.nix`. Go edit this file to include our user configurations. The file will look like something like this.

    { config, pkgs, ... }:

    {
      # Let Home Manager install and manage itself.
      programs.home-manager.enable = true;

      imports = [
        /home/lobre/Lab/nix-home/home.nix
      ];

      home.stateVersion = "19.09";
    }

You also want to symlink the `config.nix` file to allow unfree packages to be installed.

    ln -sf /home/lobre/Lab/nix-home/home/config.nix $HOME/.config/nixpkgs/config.nix

You can finally apply the configuration.

    home-manager switch -b back

At the end of the process, reboot the machine.

If you want to add custom wallpapers, download them into `~/Pictures/Wallpapers` and they will be randomly applied every 20 minutes.
