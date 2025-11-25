{
  config,
  ...
}:
{
  age.secrets = {
    keycloak-db-pass-file = {
      file = ../secrets/keycloak-db-pass.age;
    };
  };

  services.keycloak = {
    enable = true;

    # initialAdminPassword = "changeme";

    database = {
      createLocally = true;
      host = "localhost";
      passwordFile = config.age.secrets.keycloak-db-pass-file.path;
      type = "mariadb";
      username = "keycloak";
    };

    settings = {
      hostname = "keycloak.fsim-ev.de";
      http-enabled = true;
      proxy-headers = "xforwarded";
      hostname-strict = false;
      http-port = 17405;
      bootstrap-admin-username = "tmpadm";
      bootstrap-admin-password = "changeme";
    };
  };

  services.nginx.virtualHosts = {
    "keycloak.fsim-ev.de" = {
      locations."/" = {
        proxyWebsockets = true;
        proxyPass = "http://localhost:${builtins.toString config.services.keycloak.settings.http-port}";
      };
      forceSSL = true;
      enableACME = true;
    };
  };

  # should be able to remove them at some point
  systemd.services."keycloak".environment = { "KC_TRUSTSTORE_PATHS" = "/etc/nixos/certs"; };
}
