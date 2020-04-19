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
        ./system/configuration.nix
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
        /home/lobre/Lab/nix-home/home/config.nix
        /home/lobre/Lab/nix-home/home/term.nix
        /home/lobre/Lab/nix-home/home/gui.nix
      ];

      home.stateVersion = "19.09";
    }

You can finally apply the configuration.

    home-manager switch -b back

At the end of the process, reboot the machine.

If you want to add custom wallpapers, download them into `~/Pictures/Wallpapers` and they will be randomly applied every 20 minutes.

## Non NixOS setup

If you want to apply the user configurations without having NixOS as the operating system, you just have to follow the previous section with home-manager. That means it will work on any operating system that support the Nix package manager.

However, you will still have to make sure to import `/home/lobre/Lab/nix-home/non-nixos.nix` in your home-manager configuration.

As well, if you want `zsh` to be your default login shell, you will have to add the Nix zsh to the authorised shells.

    $ cat /etc/shells
    # /etc/shells: valid login shells
    /bin/sh
    /bin/dash
    /bin/bash
    /bin/rbash
    /usr/bin/screen

    # Add zsh from home manager install
    /home/lobre/.nix-profile/bin/zsh

    $ chsh -s /home/lobre/.nix-profile/bin/zsh

In the user configuration, i3 is launched using the ~/.xsession user file. That means the display manager should have an option to run the default user session for this ~/.xsession file to be taken into account. Here is an example of configuration to create a default user session entry. You need to create a file `/usr/share/xsessions/default.desktop` as follows.

    [Desktop Entry]
    Name=Default
    Comment=This runs the default user session
    Exec=default
    Icon=

## Theming

Colors in terminal emulators were first standardized using some ANSI escape sequences. See https://en.wikipedia.org/wiki/ANSI_escape_code.

The original specification supported only 8 colors but terminal emulators rapidly started to support 16, 256 and even the complete range of colors (called "true colors"). However, most terminal utilities use only the main 16 colors defined as shown in the following table.

![Screenshot](https://github.com/lobre/nix-config/raw/master/terminal-colors.png)

As I am also using graphical tools like i3, i3bar, rofi, urxvt and so on, theming is however a much broader scope than just the terminal palette. Colors should be consistent across the whole graphical environment. In order to achieve a successful theming, I like to restrict myself to only use 16 colors, staying close to the 16-terminal-colors concept defined in the above table. However, I don't want to be restricted to the named colors black, red, green, yellow, blue, magento, cyan and white. So here is the reference I will use instead.

| Normal        | Alt             |
| ------------- |-----------------|
| foreground    |                 |
| background    |                 |
| color dark    | color dark alt  |
| color 1       | color 1 alt     |
| color 2       | color 2 alt     |
| color 3       | color 3 alt     |
| color 4       | color 4 alt     |
| color 5       | color 5 alt     |
| color 6       | color 6 alt     |
| color light   | color light alt |

It is pretty much the same except that I have replaced the color names by numbers from 1 to 6, and I have added two specific colors called "dark" and "light".
The goal is to define the theme and then use these color names in all the configuration files instead of directly putting the color code.

### Implementation

All the different utilites have different configuration files and configuration formats. That's why it is difficult to establish a central global theme. In normal circumstances, that would require using something like a template preprocessor that would replace colors in each configuration file by colors defined in a global theme. I am however lucky because I use nix and home-manager here. It will enable to have this theming behavior with a simple implementation.

I have decided to use a home-manager module to do so. This module defines the colors that are then referenced in all necessary configuration files using regular nix variables fetched from the theme module.

You can check the implementation in `home/gui/theme.nix`. It also references fonts and a special urgent color.

To help discovering and applying new themes, I like using the `terminal.sexy` web utility. I just need to translate the generated theme to my `theme.nix` file, which is a simple operation. Then, I execute `home-manager switch -b bak` and my desktop suddenly repaints.

https://terminal.sexy/
