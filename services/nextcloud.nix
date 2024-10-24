{
  pkgs,
  config,
  ...
}:{
  age.secrets = {
    nextcloud-admin-pass = rec { 
      file = ../secrets/nextcloud-admin-pass.age;
      owner = "nextcloud";
      group = owner;
    };
  };

  services.nextcloud = {
    enable = true;
    package = pkgs.nextcloud29.overrideAttrs {
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
  # loglevel = 2;
  # log_type = "syslog";
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

  services.nginx.virtualHosts.${config.services.nextcloud.hostName} = {
    forceSSL = true;
    enableACME = true;
  };
}
