{ config, ... }:
{
  services.uptime-kuma = {
    enable = true;
    settings = {
      PORT = "4000";
    };
  };

  services.nginx.virtualHosts."status.fsim-ev.de" = {
    forceSSL = true;
    enableACME = true;

    locations."/".proxyPass = "http://localhost:${config.services.uptime-kuma.settings.PORT}";
  };
}
