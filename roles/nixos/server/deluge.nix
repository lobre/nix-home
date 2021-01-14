{ config, pkgs, secrets, ... }:

{
  services = {
    traefik.dynamicConfigOptions.http = {
      routers = {
        deluge = {
          rule = "Host(`deluge.${secrets.domain}`)";
          entryPoints = [ "web" "websecure" ];
          service = "deluge";
          middlewares = [ "redirect-to-https" ];
        };
      };

      services = {
        deluge.loadBalancer.servers = [
          { url = "http://127.0.0.1:8112"; }
        ];
      };
    };

    deluge = {
      enable = true;
      user = "lobre";
      declarative = true;
    };
  };
}

