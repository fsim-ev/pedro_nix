{
  config,
  ...
}:
{
  age.secrets = {
    vaultwarden-env.file = ../secrets/vaultwarden-env.age;
  };
  
  services.vaultwarden = {
    enable = true;
    dbBackend = "postgresql";
    configurePostgres = true;
    domain = "vault.fsim-ev.de";
    configureNginx = true;
    environmentFile = config.age.secrets.vaultwarden-env.path;

    config = {
      ROCKET_ADDRESS = "127.0.0.1";
      ROCKET_PORT = 7583;

      SSO_ENABLED = true;
      SSO_ONLY = true;
      SSO_AUTHORITY = "https://idp.fsim-ev.de/application/o/vaultwarden/";
      SSO_SCOPES = "email profile offline_access";
      SSO_ALLOW_UNKNOWN_EMAIL_VERIFICATION = false;
      SSO_CLIENT_CACHE_EXPIRATION = 0;
      SSO_SIGNUPS_MATCH_EMAIL = true;

      ORG_GROUPS_ENABLED = true;
    };
  };

  services.nginx.virtualHosts."${config.services.vaultwarden.domain}".enableACME = true;
}
