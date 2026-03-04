{
  config
  ...
}:
{
  age.secrets = {
    vaultwarden-env.file = ../secrets/vaultwarden-env.age;
  };
  
  services.vaultwarden = {
    enable = false;
    # dbBackend = "postgresql";
    # configurePostgres = true;
    domain = "prost.fsim-ev.de";
    environmentFile = config.age.secrets.vaultwarden-env.path;
    # backupDir = "";

    # have a look at
    # https://github.com/dani-garcia/vaultwarden/blob/main/.env.template
    # https://github.com/NixOS/nixpkgs/blob/nixos-25.11/nixos/modules/services/security/vaultwarden/default.nix
    config = {};
  };

  services.nginx.virtualHosts."prost.fsim-ev.de" = {
    forceSSL = true;
    enableACME = true;
    
    locations."/" = {
      proxyPass = "http://127.0.0.1:${toString config.services.vaultwarden.config.ROCKET_PORT}";
    };
  };
}
