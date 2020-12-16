# Install NixOS on Kimsufi

NixOS is not proposed as a Kimsufi template. So we need to find another way to install it. For that purpose, we will use the Rescue mode, which runs in a small Debian system. This will be enough to let us download and install NixOS.

## Boot to rescue mode

First, head to https://kimsufi.com and login to your account to access your server dashboard.

It is recommended to disable monitoring during the installation so that OVH technicians are not worried. You can disable it from the dashboard.

Then, click "NetBoot" in the top right corner and choose "Rescue". From the dropdown list, select "rescue64-pro". Confirm, and then restart your server (this can can a few minutes). You will then receive an email from OVH giving you the user and password to connect to rescue mode using ssh.

## Analysis of current system

We need to know which firmware our server is using. By running the following command, you can see that it does not have EFI. It runs in BIOS mode.

```
$ ls -l /sys/firmware/efi/
ls: cannot access /sys/firmware/efi/: No such file or directory
```

To have information about disks, run `lsblk -f`. You should see that we only have a single disk which is `/dev/sda`. Store that in a variable to simplify later steps.

```
DISK=/dev/sda
```

Now, execute `parted -l` to know more about partitions. You can also see that we have a GPT partition table.

I tend to prefer using the `sgdisk` tool to manipulate GPT tables. So that's the tool we will continue using. To check the state of partitions with `sgdisk`, use `sgdisk --print $DISK`.

```
Number  Start (sector)    End (sector)  Size       Code  Name
   1              40            2048   1004.5 KiB  EF02  bios_grub-sda
   2            4096         1050623   511.0 MiB   8300  primary
   3         1050624      3905974271   1.8 TiB     8300  primary
   4      3905974272      3907020799   511.0 MiB   8200  primary
```

Note that when having BIOS mode and a GPT table, this requires a "BIOS boot partition" often flagged "bios_grub" (https://en.wikipedia.org/wiki/BIOS_boot_partition). This partition is the first one in the list.

Then, in order, we have:
- a dedicated partition for `/boot`,
- the main partition,
- a swap partition.

I am pretty happy with the existing partition table. So we will keep it this way and install NixOS on `/dev/sda3`.

To simplify later steps, let's create variables for our partitions.

```
BOOT=/dev/sda2
ROOT=/dev/sda3
SWAP=/dev/sda4
```

## Format and mount partitions

If you have already installed an operating system on your server, it is likely that your partitions are not empty. To remedy that, we will recreate the filesystems.

```
mkfs.ext4 -L boot $BOOT
mkfs.ext4 -L root $ROOT
mkswap $SWAP
```

Nix will analyse and recognize what we want to achieve by checking mounted partitions. So let's mount them under `/mnt`.

```
# Root
mount $ROOT /mnt

# Boot
mkdir /mnt/boot
mount $BOOT /mnt/boot
```

## Allow nix to install as root

Nix normally refuses to install as root. But as we want to add it only in the rescue mode, we decide to force the installation as root. It will simplify the rest of the script, and will allow to share the same installation steps as if NixOS was installed using a regular iso image.

To do so, we create the `nixbld` group.

```
groupadd -g 30000 nixbld
useradd -u 30000 -g nixbld -G nixbld nixbld
```

## Install nix

It is now time to install the nix cli. This will give us all the necessary tools to install NixOS. To note that simply use the "single-user" installation method.

```
curl -L https://nixos.org/nix/install | sh
. $HOME/.nix-profile/etc/profile.d/nix.sh
```

Then configure the desired nix channel if you don't want to stay on "unstable".

```
nix-channel --add https://nixos.org/channels/nixos-20.09 nixpkgs
nix-channel --update
```

We also need the NixOS installation tools.

```
nix-env -f '<nixpkgs/nixos>' --arg configuration {} -iA config.system.build.{nixos-generate-config,nixos-install,nixos-enter,manual.manpages}
```

## Configure and install NixOS

You are now ready to start the configuration and installation of NixOS.

Please refer to [this page](install.md) to know how to do that.

## Reboot server to disk

To be able to boot the normal system instead of rescue mode, you will need to revert the "NetBoot" from your Kimsufi dashboard and select "Hard Drive". Then restart your server to apply.

You can also re-enable monitoring.

## After installation

To easily manage your NixOS configurations from userspace, make sure to follow what's writter on [this page](after-install.md).
