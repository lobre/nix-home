{ config, pkgs, ... }:

{
  users.users.media = {
    home = "/var/lib/media";
    description = "Media user";
    createHome = true;
  };
}
