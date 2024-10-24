{
  config,
  ...
}:{
  services.hedgedoc = {
      enable = true;
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
          url = "ldaps://dc2.hs-regensburg.de";
          providerName = "NDS Kennung";
          bindDn = builtins.readFile ../secrets/secrets/hedgedoc-bindDn;
          bindCredentials = builtins.readFile ../secrets/secrets/hedgedoc-bindCredentials;
          searchBase = "ou=HSR,dc=hs-regensburg,dc=de";
          searchAttributes = [ "displayName" "mail" "cn" ];
          searchFilter = "(cn={{username}})";
          userNameField = "displayName";
          useridField = "cn";
          tlsca="";
        };
      };
    };

  services.nginx.virtualHosts."pad.fsim-ev.de" = {
    forceSSL = true;
    enableACME = true;

    locations."/".proxyPass = "http://localhost:${builtins.toString config.services.hedgedoc.settings.port}";
  }; 
}
