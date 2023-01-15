{ config, pkgs, ... }:

let
  dataDir = "/var/lib/media";
in

{
  users.users.media = {
    group = "media";
    home = "${dataDir}";
    createHome = true;
    isSystemUser = true;
  };

  users.groups.media = { };

  systemd.tmpfiles.rules = [
    "d '${dataDir}' 0770 media media"
    "d '${dataDir}/Downloads' 0770 media media"
    "d '${dataDir}/Music' 0770 media media"
    "d '${dataDir}/Pictures' 0770 media media"
    "d '${dataDir}/Videos' 0770 media media"
    "d '${dataDir}/Videos/Movies' 0770 media media"
    "d '${dataDir}/Videos/Series' 0770 media media"
  ];
}
