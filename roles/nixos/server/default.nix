{ config, pkgs, ... }:

let
  dataDir = "/var/lib/media";
in

{
  # 8080 to allow quickly spinning a server for development
  networking.firewall.allowedTCPPorts = [ 22 80 443 8080 ];

  users.users.media = {
    group = "media";
    home = "${dataDir}";
    createHome = true;
    isSystemUser = true;
  };

  users.groups.media = { };

  # create directory structure with perms
  systemd.tmpfiles.rules = [
    "d '${dataDir}' 0770 media media"
    "d '${dataDir}/Downloads' 0770 media media"
    "d '${dataDir}/Music' 0770 media media"
    "d '${dataDir}/Pictures' 0770 media media"
    "d '${dataDir}/Videos' 0770 media media"
    "d '${dataDir}/Videos/Movies' 0770 media media"
    "d '${dataDir}/Videos/Series' 0770 media media"
  ];

  services = {
    openssh = {
      enable = true;
      extraConfig = "StreamLocalBindUnlink yes"; # for gpg agent forwarding
    };

    traefik = {
      enable = true;

      # as the docker socket is owned by the 
      # docker group, this is necessary
      # when using the docker provider.
      group = "docker";

      staticConfigOptions = {
        accessLog = true;
        api.dashboard = true;

        entrypoints = {
          web.address = ":80";
          websecure = {
            address = ":443";
            http.tls.certResolver = "letsencrypt";
          };
        };

        certificatesResolvers.letsencrypt.acme = {
          email = "loric.brevet@gmail.com";
          storage = "/var/lib/traefik/acme.json";
          tlsChallenge = true;
        };

        providers = { docker = { exposedbydefault = false; }; };
      };

      dynamicConfigOptions.http = {
        middlewares = {
          redirect-to-https.redirectScheme = {
            scheme = "https";
            port = "443";
            permanent = true;
          };

          admin-auth.basicAuth = {
            users = [ "admin:$2a$12$7fPByfeR//M6nYC/FndER.bflzGV77.i1qVMfZ.nzWWh/dj2Y8w3K" ];
          };
        };

        routers = {
          traefik = {
            rule = "Host(`traefik.lobre.io`)";
            entryPoints = [ "web" "websecure" ];
            service = "api@internal";
            middlewares = [ "redirect-to-https" "admin-auth" ];
          };

          plex = {
            rule = "Host(`plex.lobre.io`)";
            entryPoints = [ "web" "websecure" ];
            service = "plex";
            middlewares = [ "redirect-to-https" ];
          };

          deluge = {
            rule = "Host(`deluge.lobre.io`)";
            entryPoints = [ "web" "websecure" ];
            service = "deluge";
            middlewares = [ "redirect-to-https" ];
          };
        };

        services = {
          plex.loadBalancer.servers = [{ url = "http://127.0.0.1:32400"; }];
          deluge.loadBalancer.servers = [{ url = "http://127.0.0.1:8112"; }];
        };
      };
    };

    plex = {
      enable = true;
      user = "media";
      group = "media";
      openFirewall = true;
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

  users.users.mabre = {
    isNormalUser = true;
    description = "Mael Brevet";
    shell = pkgs.bash;
    extraGroups = [ "wheel" "networkmanager" "audio" "video" "docker" "media" ];

    hashedPassword = "$y$j9T$FjBD72xuYsU.8fzA66uPT.$.z56FCUhAIup3Q7fa6UoANY1M3O.e0elJZJ4TSOIcI9";
    openssh.authorizedKeys.keys = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHFwtmR2gstd8A8T60tfZ7TLd5OQMlwflUmt7k5vZCTA openpgp:0xBD1259FB" ];
  };
}

