{
  pkgs,
  config,
  stable,
  lib,
  ...
}:{
  age.secrets = {
    nextcloud-admin-pass = rec { 
      file = ../secrets/nextcloud-admin-pass.age;
      owner = "nextcloud";
      group = owner;
    };
  };


  services.collabora-online = {
    enable = true;
    port = 9980;
    settings = {
      ssl = {
        enable = false;
        termination = true;
      };

      net = {
        proto = "IPv4";
        listen = "loopback";
        post_allow.host = [ "127\\.0\\.0\\.1" ];
      };

      storage.wopi = {
        "@allow" = true;
        host = [ "cloud.fsim-ev.de" ];
      };

      server_name = "office.fsim-ev.de";
    };
  };

    systemd.services.nextcloud-config-collabora = let
    inherit (config.services.nextcloud) occ;

    wopi_url =
      "http://localhost:${toString config.services.collabora-online.port}";
    public_wopi_url = "https://${config.services.collabora-online.settings.server_name}";
    wopi_allowlist = lib.concatStringsSep "," [ "127.0.0.1" "::1" ];
  in {
    wantedBy = [ "multi-user.target" ];
    after = [ "nextcloud-setup.service" "coolwsd.service" ];
    requires = [ "coolwsd.service" ];
    script = ''
      ${occ}/bin/nextcloud-occ config:app:set richdocuments wopi_url --value ${
        lib.escapeShellArg wopi_url
      }
      ${occ}/bin/nextcloud-occ config:app:set richdocuments public_wopi_url --value ${
        lib.escapeShellArg public_wopi_url
      }
      ${occ}/bin/nextcloud-occ config:app:set richdocuments wopi_allowlist --value ${
        lib.escapeShellArg wopi_allowlist
      }
      ${occ}/bin/nextcloud-occ richdocuments:setup
    '';
    serviceConfig = { Type = "oneshot"; };
  };

  networking.hosts = {
    "127.0.0.1" = [
      config.services.nextcloud.hostName
      config.services.collabora-online.settings.server_name
    ];
    # "::1" = ["nextcloud.example.com" "collabora.example.com"];
  };

  services.nextcloud = {
    enable = true;
    package = stable.nextcloud31.overrideAttrs {
      patches = (../patches/nextcloud-remove-notify-nag.patch);
    };

    hostName = "cloud.fsim-ev.de";
    config = {
      dbtype = "pgsql";
      dbhost = "/run/postgresql"; # nextcloud will add /.s.PGSQL.5432 by itself
      adminuser = "nixi";
      adminpassFile = config.age.secrets.nextcloud-admin-pass.path;
    };

    settings = {
      overwriteprotocol = "https";
      default_phone_region = "DE";
      default_locale = "de";
      "auth.webauthn.enabled" = false;
  # loglevel = 2;
  # log_type = "syslog";
    };

    extraAppsEnable = true;
    appstoreEnable = true;

    extraApps = {
      inherit (config.services.nextcloud.package.packages.apps)

      richdocuments; # collabora office
    };

    caching = {
      apcu = true;
      redis = true;
    };

    maxUploadSize = "16G";
  };

  services.redis.servers = {
    "nextcloud" = {
      # File lock cache
      enable = true;
      user = "nextcloud";
    };
  };

  # NextCloud: ensure that postgres is running *before* running the setup
  systemd.services."nextcloud-setup" = {
    requires = [ "postgresql.service" ];
    after = [ "postgresql.service" ];
  };

  services.nginx.virtualHosts = {
    
    "${config.services.collabora-online.settings.server_name}" = {
      enableACME = true;
      forceSSL = true;

      locations."/" = {
        proxyPass =
          "http://localhost:${toString config.services.collabora-online.port}";
        proxyWebsockets = true;

        extraConfig = ''
            # Headers for WebSocket support
          proxy_set_header   Host $host;
          proxy_set_header   X-Forwarded-For $proxy_add_x_forwarded_for;
          proxy_set_header   X-Forwarded-Host $host;
          proxy_set_header   X-Forwarded-Proto $scheme;
          proxy_set_header   Upgrade $http_upgrade;
          proxy_set_header   Connection $http_connection;

        '';
      };
    };

    "${config.services.nextcloud.hostName}" = {
      forceSSL = true;
      enableACME = true;
    };
  };
}
