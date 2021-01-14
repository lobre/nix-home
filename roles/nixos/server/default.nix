{ config, pkgs, secrets, ... }:

{
  services.sshd.enable = true;

  services.traefik = {
    enable = true;
    group = "docker";

    staticConfigOptions = {
      api.dashboard = true;

      entrypoints = {
        web.address = ":80";
        websecure = {
          address = ":443";
          http.tls.certResolver = "letsencrypt";
        };
      };

      certificatesResolvers.letsencrypt.acme = {
        email = secrets.email;
        storage = "acme.json";
        tlsChallenge = true;
      };

      providers = {
        docker = {
          exposedbydefault = false;
        };
      };
    };

    dynamicConfigOptions = {
      http.routers.traefik = {
        rule = "Host(`traefik.example.in`)";
        entryPoints = [ "websecure" ];
        service = "api@internal";
      };
    };
  };
}
