{ config, pkgs, secrets, ... }:

let 
  authFile = pkgs.writeText "deluge-auth" ''
    localclient:${secrets.deluge.password}:10
    ${secrets.deluge.user}:${secrets.deluge.password}:10
  '';
in

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
      web.enable = true;
      declarative = true;
      openFirewall = true;
      user = "lobre";
      authFile = authFile;

      config = {
        allow_remote = true;
        download_location = "/home/lobre/Downloads/";
        stop_seed_at_ratio = true;
        stop_seed_ratio = 2;
        enabled_plugins = [ "Label" ];
      };
    };
  };
}

