{ config, pkgs, secrets, ... }:

{
  # 8080 to allow quickly spinning a server for development
  networking.firewall.allowedTCPPorts = [ 22 80 443 8080 ];

  services = {
    sshd.enable = true;

    traefik = {
      enable = true;

      # as the docker socket is owned by the 
      # docker group, this is necessary
      # when using the docker provider.
      group = "docker";

      staticConfigOptions = {
        accessLog = true;

        entrypoints = {
          web.address = ":80";
          websecure = {
            address = ":443";
            http.tls.certResolver = "letsencrypt";
          };
        };

        certificatesResolvers.letsencrypt.acme = {
          email = secrets.email;
          storage = "/var/lib/traefik/acme.json";
          tlsChallenge = true;
        };

        providers = {
          docker = {
            exposedbydefault = false;
          };
        };
      };

      dynamicConfigOptions.http.middlewares = {
        redirect-to-https.redirectScheme = {
          scheme = "https";
          port = "443";
          permanent = true;
        };
      };
    };
  };

  imports = [
    ./plex.nix
    ./deluge.nix
  ];
}

