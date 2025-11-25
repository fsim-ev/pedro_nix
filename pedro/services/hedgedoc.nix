{
  config,
  ...
}:
{
  age.secrets = {
    hedgedoc-env-file = {
      file = ../secrets/hedgedoc-env-file.age;
    };
  };

  services.hedgedoc = {
    enable = true;
    environmentFile = config.age.secrets.hedgedoc-env-file.path;
    settings = rec {
      domain = "pad.fsim-ev.de";
      port = 3003;
      protocolUseSSL = true;
      hsts.enable = true;
      allowOrigin = [
        domain
      ];
      csp = {
        enable = true;
        upgradeInsecureRequest = "auto";
        addDefaults = true;
      };

      db = {
        dialect = "postgres";
        host = "/run/postgresql";
        username = "hedgedoc";
        database = "hedgedoc";
      };

      allowAnonymous = false;
      defaultPermission = "private"; # Privacy first
      allowFreeURL = false; # for even more privacy

      allowGravatar = false;

      email = false;
      allowEmailRegister = false;
      ldap = {
        url = "ldaps://adldap.hs-regensburg.de";
        providerName = "NDS Kennung";
        searchBase = "ou=HSR,dc=hs-regensburg,dc=de";
        searchAttributes = [
          "displayName"
          "mail"
          "cn"
        ];
        searchFilter = "(cn={{username}})";
        userNameField = "displayName";
        useridField = "cn";
      };
    };
  };


  systemd.services."hedgedoc".serviceConfig.ReadOnlyPaths = ["/etc/nixos/certs/oth_ldap.pem"];
  systemd.services."hedgedoc".environment = rec {
    # CMD_LDAP_TLS_CA="/etc/nixos/certs/oth_ldap.pem";
    # SSL_CERT_FILE = ../../certs/oth_ldap.pem;
    # NODE_EXTRA_CA_CERTS = SSL_CERT_FILE;
    NODE_OPTIONS="--use-openssl-ca";

  };

  services.nginx.virtualHosts."pad.fsim-ev.de" = {
    forceSSL = true;
    enableACME = true;

    locations."/" = {
      proxyPass = "http://localhost:${builtins.toString config.services.hedgedoc.settings.port}";
      proxyWebsockets = true;
    };

    extraConfig = ''
      proxy_set_header X-Forwarded-Host $http_host;
      proxy_set_header X-Forwarded-URI $request_uri;
      proxy_set_header X-Forwarded-Ssl on;
      proxy_set_header X-Forwarded-For $remote_addr;
      proxy_set_header X-Real-IP $remote_addr;
    '';
  };
}
