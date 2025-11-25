{
  config,
  ...
}:{
    age.secrets = {
      authentik-env.file = ../secrets/authentik-env.age;
      authentik-ldap-env.file = ../secrets/authentik-ldap-env.age;
    };

    services.authentik = {
      enable = true;
      environmentFile = config.age.secrets.authentik-env.path;
      nginx = {
        enable = true;
        host = "idp.fsim-ev.de";
        enableACME = true;
      };
    };

    services.authentik-ldap = {
      enable = true;
      environmentFile = config.age.secrets.authentik-ldap-env.path;
    };
  }
