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
        websecure.address = ":443";
      };

      certificatesResolvers.lets-encrypt.acme = {
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
    };
  };
}
