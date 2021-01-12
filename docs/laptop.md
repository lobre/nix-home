# Install NixOS on your laptop

Here is a quick tutorial that will help installing NixOS on a regular ext4 partition. This tutorial covers a physical installation or a virtual machine installation (instructions for VMWare Player).

## NixOS iso

Beforehand, make sure to have downloaded the latest mini iso image of NixOS. Mini is sufficient as we don’t require the KDE desktop environment and all the stuff that comes out of it.

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

We first need to know which firmware we are running. If you don’t know about EFI/BIOS, refer to [this documentation page](firmwares.md).

### EFI or BIOS?

This is a physical implementation. If running EFI, the following directory should exist on your machine. Otherwise, you are running BIOS.

```
ls -l /sys/firmware/efi/
```

For VMWare Player, the firmware is emulated so you can decide which one to use. Go edit the vmx file of your VM (`C:\Users\<user>\Documents\Virtual Machines\<vm>.vmx` for Windows) and choose one or another.

```
firmware = "bios"
firmware = "efi"
```

### GPT partition table

Instructions will be given for both EFI and BIOS firmwares. However, as it is more recent than MBR, **we decide to create a GPT table whatever the firmware**.

You can first have a look to blocks using the `lsblk` command. It will give you an overview of disks and their sizes. We will create a `$DISK` variable that will hold the disk on which we want to install NixOS.

```
DISK=/dev/sda
```

Then, to create and manipulate the GPT table, we will be using the `sgdisk` utility which is installed in the Nix iso image. You can find the manual page at the following location if needed:

https://linux.die.net/man/8/sgdisk

Here is a quick cheatsheet on how to use it.

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

If at the opposite you want to clear a filesystem (by removing labels), you can use `wipefs --all /dev/sdx` on your specific partition.

To continue, choose one of the two following sections according to your firmware.

#### EFI

Apply the following commands.

```
sgdisk -n 0:0:+1GiB -t 0:ef00 -c 0:boot $DISK // EFI boot partition
sgdisk -n 0:0:-8GiB -t 0:8300 -c 0:root $DISK // Main partition for the root filesystem (all space except 8GiB at the end)
sgdisk -n 0:0:0 -t 0:8200 -c 0:swap $DISK // 8GiB of swap
```

You can check the output with `sgdisk --print $DISK`.

Note that in EFI mode, NixOS will use the EFI boot partition as its `/boot` partition.

Then define these environment variables that will be used in the next sections.

```
BOOT=/dev/sda1
ROOT=/dev/sda2
SWAP=/dev/sda3
```

Define the filesystem for the boot partition. We need to use "vfat" as the filesystem because the boot partition is also the EFI system partition. And according to the UEFI specification, this partition should be formatted with a FAT filesystem (https://en.wikipedia.org/wiki/EFI_system_partition).

```
mkfs.vfat -n boot $BOOT
```

Then, create the main filesystem.

```
mkfs.ext4 -L root $ROOT
```

Note that the NixOS manual recommends that you assign a unique symbolic label to the filesystem (`-n` option of `mkfs.vfat` or `-L` option of `mkfs.ext4`) since this makes the file system configuration independent from device changes.

To finish, create the swap filesystem.

```
mkswap $SWAP 
```

#### BIOS

Apply the following commands. Note that as we are using a GPT table on a BIOS firmware, we need to create a "BIOS boot partition" (https://en.wikipedia.org/wiki/BIOS_boot_partition).

```
sgdisk -n 0:0:+1MiB -t 0:ef02 -c 0:grub $DISK // BIOS boot partition
sgdisk -n 0:0:+1GiB -t 0:ea00 -c 0:boot $DISK // Actual boot partition that will be mounted to /boot
sgdisk -n 0:0:-8GiB -t 0:8300 -c 0:root $DISK // Main partition for the root filesystem (all space except 8GiB at the end)
sgdisk -n 0:0:0 -t 0:8200 -c 0:swap $DISK // 8GiB of swap
```

You can check the output with `sgdisk --print $DISK`.

Then, create the following environment variables.

```
BOOT=/dev/sda2
ROOT=/dev/sda3
SWAP=/dev/sda4
```

Define the filesystem for the boot partition. We don’t have the same constraints than EFI here so we can use the filesystem we want. For convenience, we will use `ext4`.

```
mkfs.ext4 -L boot $BOOT
```

Then, create the main filesystem.

```
mkfs.ext4 -L root $ROOT
```

Note that the NixOS manual recommends that you assign a unique symbolic label to the filesystem using the option `-L label` since this makes the file system configuration independent from device changes.

To finish, create the swap filesystem.

```
mkswap $SWAP 
```

## Mount filesystems

Let’s mount the partitions.

```
# Root
mount $ROOT /mnt

# Boot
mkdir /mnt/boot
mount $BOOT /mnt/boot
```

## Configure and install NixOS

To finish the installation, refer to [this page](install.md).

Once installed, make sure to apply what is written on [this page](userspace-configurations.md).
