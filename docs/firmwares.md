# EFI vs BIOS firmwares

Back in the day, BIOS was the preferred boot method present in chipsets. Now, UEFI is the new de facto standard even if people continue to call it BIOS.

BIOS and UEFI are physical firmwares implemented directly at the hardware level. A machine is built using one or the other.

It is important to understand the differences in the boot process for these two firmwares. At some point, what matters is to have a boot loader executed. A boot loader is a program responsible for loading operating systems. In Linux, GRUB is often the preferred boot loader. Windows also has its specific boot loader.

The BIOS loads the first 512 bytes from the hard drive of the selected boot device – these 512 bytes are what is commonly known as the MBR, or the Master Boot Record. For Linux, GRUB will have written into the MBR to allow its execution (not all of GRUB's logic is written in MBR, some parts are also written in the so called MBR gap).

The UEFI firmware however loads files stored on the ESP (or EFI system partition). An ESP is a specific partition that contains the boot loaders or kernel images for all installed operating systems. ESP is part of the UEFI specification. The specification also defines the GPT standard for the layout of partition tables.

So as a general rule, we almost always have the two matches:
 - BIOS = MBR
 - UEFI = GPT

But there are exceptions.

UEFI firmware does not execute the code in the MBR, except when booting in legacy BIOS mode through the Compatibility Support Module (CSM).

There is also a possibility for BIOS to be used with a GPT partition table. As a reminder, BIOS does not care about GPT and your hard drives. It simply loads MBR and transfer control to the boot loader in MBR. To note that a GPT drive still has a protective MBR space at the beginning for legacy purpose. So for this match to exist, you just need a boot loader that supports GPT. It turns out GRUB is one of them.

However in this situation, there is no "MBR gap" in which some parts of GRUB are usually stored. To solve this problem, GRUB expects a specific additional partition called "BIOS boot partition" often flagged "bios_grub" (https://en.wikipedia.org/wiki/BIOS_boot_partition).

## /boot directory

On a Linux filesystem, the `/boot/` directory holds files used in booting the operating system.

This should not be confused with the previous BIOS/UEFI/MBR/GPT concepts. It is not correlated.

It is sometimes recommended to mount `/boot` to a dedicated partition but it is not mandatory.

However, it turns out NixOS has a quite particular approach because when installed in UEFI mode, it by default uses the ESP partition as its `/boot` partition.