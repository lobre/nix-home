{ config, lib, pkgs, ... }:

{
  boot.supportedFilesystems = ["zfs"];

  # Prompt user at boot for password to unencrypt root ZFS filesystem
  boot.zfs.requestEncryptionCredentials = true;

  services.zfs.autoSnapshot.enable = true;

  # Autoscrub will attempt to repair silent data corruption by checking
  # integrity of all stored data against the stored checksums.
  services.zfs.autoScrub.enable = true;

  # Erase the root dataset on each boot by rollbacking
  # to the blank snapshot.
  boot.initrd.postDeviceCommands = lib.mkAfter ''
    zfs rollback -r rpool/root@blank
  '';

  # ZFS sets the disk’s scheduler to none when it has control
  # over the entire disk. As we created a boot
  # partition, we manually set it to none.
  boot.kernelParams = [ "elevator=none" ];
  
  # If OpenSSH enabled during boot, it will allow to unlock
  # the encrypted pool.
  boot.initrd.network = {
    # automatically load the zfs password prompt on login
    # and kill the other prompt so boot can continue
    postCommands = ''
      echo "zfs load-key -a; killall zfs" >> /root/.profile
    '';
  };
}
