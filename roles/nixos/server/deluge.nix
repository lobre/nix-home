{ config, pkgs, ... }:

{
  services = {
    traefik.dynamicConfigOptions.http = {
      routers = {
        deluge = {
          rule = "Host(`deluge.lobre.io`)";
          entryPoints = [ "web" "websecure" ];
          service = "deluge";
          middlewares = [ "redirect-to-https" ];
        };
      };

      services = {
        deluge.loadBalancer.servers = [{ url = "http://127.0.0.1:8112"; }];
      };
    };

    deluge = {
      enable = true;
      package = pkgs.deluged; # non gtk version
      web.enable = true;
      declarative = true;
      openFirewall = true;
      user = "media";
      group = "media";

      # automatically generate a random password in auth.stateful for the local ui
      authFile = "${config.services.deluge.dataDir}/.config/deluge/auth.stateful";

      config = {
        allow_remote = true;
        download_location = "/var/lib/media/Downloads/";
        stop_seed_at_ratio = true;
        stop_seed_ratio = 2;
        enabled_plugins = [ "Label" ];
      };
    };
  };
}

