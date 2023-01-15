{ config, pkgs, ... }:

{
  services = {
    traefik.dynamicConfigOptions.http = {
      routers = {
        plex = {
          rule = "Host(`plex.lobre.io`)";
          entryPoints = [ "web" "websecure" ];
          service = "plex";
          middlewares = [ "redirect-to-https" ];
        };
      };

      services = {
        plex.loadBalancer.servers = [{ url = "http://127.0.0.1:32400"; }];
      };
    };

    plex = {
      enable = true;
      user = "media";
      group = "media";
      openFirewall = true;
    };
  };
}
