{
  config,
  ...
}:
let
  domain = "documents.fsim-ev.de";
in
{
  age.secrets = {
    paperless-ngx-admin.file = ../secrets/paperless-ngx-admin.age;
  };

  services.paperless = {
    enable = true;

    inherit domain;

    dataDir = "/var/lib/paperless";

    settings = {
      PAPERLESS_URL = "https://${domain}";
    };

    passwordFile = config.age.secrets.paperless-ngx-admin.path;
  };

  services.nginx.virtualHosts."${domain}" = {
    enableACME = true;
    forceSSL = true;

    locations."/".proxyPass =
      "http://${config.services.paperless.address}:${toString config.services.paperless.port}";
  };
}
