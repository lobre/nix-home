# How to install NixOS with ZFS

The goal is to have NixOS installed with an single encrypted zpool for the root filesystem (no mirroring or raidz). This tutorial can help either for a physical installation or a virtual machine installation (instructions for VMWare Player).

We will explain how to setup ZFS using quite the same approach as the one described by Graham Christensen in its blog posts.

https://grahamc.com/blog/nixos-on-zfs

https://grahamc.com/blog/erase-your-darlings

That means having an "opting out" strategy by rollbacking the root partition at every boot using a blank snapshot. That brings a new computer smell at every reboot and almost no state is persisted by default (immutable infrastructure).

## Overview of the ZFS datasets

```
rpool/
├── root      // mounted to /
├── home      // mounted to /home
├── nix       // mounted to /nix
├── docker    // mounted to /var/lib/docker
└── persist   // mounted to /persist
```

A few comments:

- `root` will be reverted to a blank snapshot at every boot (no state).
- `home` is the home of all users and will be snapshotted on a regular basis.
- `nix` contains all nix built stuff that could be regenerated from our nix configuration.
- `docker` is separated into its specific dataset because we want to keep containers / images across reboots (state is important for convenience but does not need backups as containers can be rebuilt).
- `persist` is for backups of single files/directories that will be explicitly linked to `/persist`.

## NixOS iso

Beforehand, make sure to have downloaded the latest mini iso image of NixOS. Mini is sufficient as we don’t require the KDE desktop environment and all the stuff that come with it.

https://nixos.org/download.html

Boot the iso either in your VMWare Player, or using a bootable usb stick.

## Switch the keyboard layout

If needed, feel free to change the keyboard layout. My personal choice is french bepo.

```
sudo loadkeys fr-bepo
```

As I always need a reference to a qwerty layout to type it, here it is.

![Screenshot](qwerty.png)

## Get a root shell

For convenience, we will drop in a root shell so we don’t have to type `sudo` for all upcoming commands.

```
sudo -i
```

## Networking in the installer

Networking is necessary for the installer, since it will download lots of stuff. If you have a wired connection, please ignore this step. Otherwise, configure the wifi with `wpa_supplicant`.

```
wpa_supplicant -B -i interface -c <(wpa_passphrase 'SSID' 'key')
```

Make sure you can ping Google (`ping www.google.com`).

## Partitioning and formatting

If you need general information about partition tables and firmwares, please read the following page.

[Firmwares, EFI vs BIOS](firmwares.md)

Instructions will be given for both EFI and BIOS firmwares. However, as it is more recent than MBR, **we decide to create a GPT table whatever the firmware**.

To create and manipulate the GPT table, we will be using the `sgdisk` utility. You can find the manual page at the following location if needed:

https://linux.die.net/man/8/sgdisk

You can have a look to blocks using the `lsblk` command. It will give you an overview of disks and their sizes.

### EFI or BIOS?

This is a physical implementation. If running EFI, the following directory should exist on your machine. Otherwise, you are running BIOS.

```
ls -l /sys/firmware/esi/
```

For VMWare Player, the firmware is emulated so you can decide which one to use. Go edit the vmx file of your VM (`C:\Users\<user>\Documents\Virtual Machines\<vm>.vmx` for Windows) and choose one or another.

```
firmware = "bios"
firmware = "efi"
```

### Disks by ID

When partitioning for a ZFS filesystem, it is important to reference the "by-id" unique identifiers of devices instead of the more general aliases (`/dev/sda`). If this rule is not enforced, ZFS can choke on imports.

Check that you see your main disk on which the system will be installed in the following directory:

```
ls -l /dev/disk/by-id
```

If there are multiple ids for a same disk, you are free to use whatever you wish for your zpool drive identification.

By default, VMWare Player does not provide information needed by udev to generate `/dev/disk/by-id`.

To enable it, edit to `C:\Users\<user>\Documents\Virtual Machines\<vm>.vmx` and add `disk.EnableUUID = "TRUE"`.

We will use an environment variable to store the "by-id" of the main disk as we will have to reference it a bunch of times.

```
SDA="$(ls /dev/disk/by-id/ | grep ata | head -n1)"
DISK=/dev/disk/by-id/$SDA

echo $SDA
echo $DISK
```

### Create the GPT partition table

We will now use the `sgdisk` to setup the GPT partition table. Instructions given in this documentation are for a single disk and it will take the whole disk space.

In case you want to achieve a different setup (dual boot or multiple disks), here are a few tips on how to use `sgdisk`.

```
# print gpt table information
sgdisk --print $DISK

# print detailed info about a specific partition
sgdisk -i 2 $DISK

# list the available partition type codes
sgdisk --list-types

# change the name of a partition
sgdisk -c 1:grub $DISK

# change the type of a partition
sgdisk -t 1:ef02 $DISK

# delete a partition
sgdisk -d 1 $DISK

# delete all partitions
sgdisk --zap-all $DISK

# sort partitions to have successive partition numbers
sgdisk -s $DISK
```

To note that you can also make use of other utilities to format partitions to specific filesystems (`mkfs.ext4`, `mkfs.vfat`, ...).

To continue, choose one of the two following sections according to your firmware.

#### EFI

Apply the following commands.

```
sgdisk -n 0:0:+1GiB -t 0:ef00 -c 0:boot $DISK // EFI boot partition
sgdisk -n 0:0:-8GiB -t 0:bf01 -c 0:zfs $DISK // Main partition for the ZFS filesystem (all space except 8GiB at the end)
sgdisk -n 0:0:0 -t 0:8200 -c 0:swap $DISK // 8GiB of swap
```

You can check the output with `sgdisk --print $DISK`.

Note that in EFI mode, NixOS will use the EFI boot partition as its `/boot` partition.

Then define these environment variables that will be used in the next sections.

```
BOOT=$DISK-part1
ZFS=$DISK-part2
SWAP=$DISK-part3
```

Define the filesystem for the boot partition. We need to use "vfat" as the filesystem because the boot partition is also the EFI system partition. And according to the UEFI specification, this partition should be formatted with a FAT filesystem (https://en.wikipedia.org/wiki/EFI_system_partition).

```
mkfs.vfat -n boot $BOOT
```

Note that the NixOS manual recommends that you assign a unique symbolic label to the filesystem using the option `-n label` since this makes the file system configuration independent from device changes.

To finish, create the swap filesystem.

```
mkswap $SWAP 
```

#### BIOS

Apply the following commands. Note that as we are using a GPT table on a BIOS firmware, we need to create a "BIOS boot partition" (https://en.wikipedia.org/wiki/BIOS_boot_partition).

```
sgdisk -n 0:0:+1MiB -t 0:ef02 -c 0:grub $DISK // BIOS boot partition
sgdisk -n 0:0:+1GiB -t 0:ea00 -c 0:boot $DISK // Actual boot partition that will be mounted to /boot
sgdisk -n 0:0:-8GiB -t 0:bf01 -c 0:zfs $DISK // Main partition for the ZFS filesystem (all space except 8GiB at the end)
sgdisk -n 0:0:0 -t 0:8200 -c 0:swap $DISK // 8GiB of swap
```

You can check the output with `sgdisk --print $DISK`.

Then, create the following environment variables.

```
BOOT=$DISK-part2
ZFS=$DISK-part3
SWAP=$DISK-part4
```

Define the filesystem for the boot partition. We don’t have the same constraints than EFI here so we can use the filesystem we want. For convenience, we will use `ext4`.

```
mkfs.ext4 -L boot $BOOT
```

Note that the NixOS manual recommends that you assign a unique symbolic label to the filesystem using the option `-L label` since this makes the file system configuration independent from device changes.

To finish, create the swap filesystem.

```
mkswap $SWAP 
```

## Configuration of ZFS

### zpool

This is going to be a single disk on our machine and it will use encryption. The most famous encryption solution for disk is [LUKS](https://en.wikipedia.org/wiki/Linux_Unified_Key_Setup).

However, for simplicity sake, we will not use it and rely on the native encryption capabilities of ZFS here.

Let’s create the encrypted zpool on the ZFS partition.

```
zpool create -o altroot="/mnt" -O mountpoint=none -O encryption=aes-256-gcm -O keyformat=passphrase rpool $ZFS
```

This will ask you to create a passphrase that you will have to use at boot to unencrypt the disk.

The mountpoint is set to "none" as we don’t need to mount it. We will only mount children datasets.

We choose not to pick the `ashift` option and just allow ZFS to guess.

### datasets

We will here create datasets following our above guideline with `safe` and `local` levels. For datasets that need to be mounted by NixOS, we set the mountpoint to legacy.

```
zfs create -p -o mountpoint=legacy rpool/root
zfs create -p -o mountpoint=legacy rpool/home
zfs create -p -o mountpoint=legacy rpool/nix
zfs create -p -o mountpoint=legacy rpool/docker
zfs create -p -o mountpoint=legacy rpool/persist
```

The `-p` option allows to implicitly create non-existing parent datasets for us. They would inherit properties from the parent zpool and so would not have any mountpoint. Here we don’t have any but this option can be handy to know if we add more levels in the future. 

Then, we will create a blank snapshot of the root dataset even before mounting it, so we can revert at each boot to this snapshot.

```
zfs snapshot rpool/root@blank
```

You can review it with `zfs list -t snapshot`.

We will finish by adding additional properties to our datasets.

```
# Add compression and let ZFS choose the best algorithm
zfs set compression=on rpool/home

# Auto snapshots the home and persist datasets
zfs set com.sun:auto-snapshot=true rpool/home
zfs set com.sun:auto-snapshot=true rpool/persist

# The dataset containing journald’s logs (where /var lives) should have these options to allow regular users to read their journal
zfs set xattr=sa rpool/root
zfs set acltype=posixacl rpool/root

# Nix doesn’t use atime, so the following makes sense
zfs set atime=off rpool/nix
```

## Mount filesystems

Let’s mount the boot partition and each datasets.

```
# Root
mount -t zfs rpool/root /mnt

# Boot
mkdir /mnt/boot
mount $BOOT /mnt/boot

# Home
mkdir /mnt/home
mount -t zfs rpool/home /mnt/home

# Nix
mkdir /mnt/nix
mount -t zfs rpool/nix /mnt/nix

# Docker
mkdir -p /mnt/var/lib/docker
mount -t zfs rpool/docker /mnt/var/lib/docker

# Persist
mkdir /mnt/persist
mount -t zfs rpool/persist /mnt/persist
```

## Configure NixOS before installation

### Import configuration from GitHub

All my configurations are stored in this GitHub repository. So we will have to download them before launching the installation process. Here is how I do it.

We need `git` installed and then, we clone the repository in `/mnt/etc/nixos`, where the installer expects them.

```
nix-env -iA nixos.git
git clone https://github.com/lobre/nix-home /mnt/etc/nixos
```

### Create configuration.nix

In the repository, `configuration.nix` and `hardware-configuration.nix` are excluded in the `.gitignore`. So these files don’t exist yet.

In this step, we will create `configuration.nix` starting from the skeleton `configuration.skel.nix` available at the root of the repository.

```
cp /mnt/etc/nixos/configuration.skel.nix /mnt/etc/nixos/configuration.nix
```

Then, you can start to edit this file, uncomment and fill in the missing configurations.

### Generate hardware-configuration.nix

NixOS installer is able to detect our configuration and generate a `hardware-configuration.nix` for us. It will also detect our previous ZFS settings and will report them.

Use the following command to execute the generation. Note that as `configuration.nix` already exists, it won’t get overriden.

```
nixos-generate-config --root /mnt
```

You can throw a look at the generated hardware configuration in `/mnt/etc/nixos/hardware-configuration.nix`.

## Installation

Before moving to the installation, make sure to save a copy of `configuration.nix` and `hardware-configuration.nix`. Otherwise, with our ZFS setup, they will get removed as we rollback the root dataset to a blank snapshot at boot. We can safely move them to the persist dataset.

```
cp /mnt/etc/nixos/configuration.nix /mnt/persist/
cp /mnt/etc/nixos/hardware-configuration.nix /mnt/persist/
```

Once ready, simply launch the installation command and reboot once it is finished.

Note that we decide to not set the root password as our configuration will create a user with root permissions.

```
nixos-install --no-root-passwd
reboot
```

## After installation

Now that the system is installed and booted, you will want to re-clone this project in `~/Lab/nix-home` and recover our `configuration.nix` and `hardware-configuration.nix` files.

```
git clone https://github.com/lobre/nix-home ~/Lab/nix-home
sudo chown ${USER}:users /persist/{hardware-,}configuration.nix
sudo mv /persist/{hardware-,}configuration.nix ~/Lab/nix-home/
```

Then, make sure to re-apply the configurations to see if everything works as expected. To note that we use a custom script aware of the location of our configurations.

```
sudo ~/Lab/nix-home/nix-switch system
```

## Troubleshooting

### Mount filesystem from live usb

If you find yourself stuck outside and need to have access to the ZFS filesystem from a live usb, follow these instructions.

Start your NixOS live usb again.

You need then to import the pool. You will be prompted to enter your passphrase to decrypt the disk.

```
zpool import -l rpool
```

Note that we are using the `-l` flag when importing a pool that contains encrypted datasets keys. You might also need to use the `-f` flag to force the import. That happens when the zpool has not been exported before (`zpool export`).

Then, as we have used legacy mountpoints, we cannot mount or datasets with `zfs mount -a`. Instead, we need to rely on the regular `mount` command.

```
mount -t zfs rpool/local/root /mnt
umount /mnt
```

#### Rebuild configuration from live usb

`nixos-generate-config` will regenerate the hardware config, but if it finds `configuration.nix` already exists it will leave it alone. And `nixos-install` is designed such that it can be safely executed as many times as needed.

So you can simply re-import your pool as stated in last section, mount your partitions again and re-execute `nixos-install`.

### Mount snapshot

We can mount snapshots as read-only the same way as datasets.

It can be helpful to see its content.

```
mkdir /snapshot
mount -t zfs rpool/root@blank /snapshot
umount /snapshot && rmdir /snapshot
```
