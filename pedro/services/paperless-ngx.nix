{
  config,
  ...
}:{
  age.secrets = {
    paperless-ngx-admin.file = ../secrets/paperless-ngx-admin.age;
  };

  services.paperless = {
    enable = true;

    dataDir = "/var/lib/paperless";

    settings = {
      PAPERLESS_URL = "https://documents.fsim-ev.de";
    };

    passwordFile = config.age.secrets.paperless-ngx-admin.path;
  };

  services.nginx.virtualHosts."documents.fsim-ev.de" = {
    enableACME = true;
    forceSSL = true;

    locations."/".proxyPass = "http://${config.services.paperless.address}:${toString config.services.paperless.port}";
  };
}
