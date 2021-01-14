{ config, pkgs, secrets, ... }:

{
  services = {
    traefik.dynamicConfigOptions.http = {
      routers = {
        plex = {
          rule = "Host(`plex.${secrets.domain}`)";
          entryPoints = [ "web" "websecure" ];
          service = "plex";
          middlewares = [ "redirect-to-https" ];
        };
      };

      services = {
        plex.loadBalancer.servers = [
          { url = "http://127.0.0.1:32400"; }
        ];
      };
    };

    plex = {
      enable = true;
      user = "lobre";
      openFirewall = true;
    };
  };
}
