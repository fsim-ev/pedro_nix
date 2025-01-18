{
  config,
  ...
}:{
  services.grafana = {
    enable = true;

    settings = {
      server = {
        http_addr = "127.0.0.1";
        http_port = 45128;

        domain = "dev.fsim-ev.de";
      };

      analytics.reporting_enabled = false;
    };
  };

  services.nginx.virtualHosts."${config.services.grafana.settings.server.domain}" = {
    enableACME = true;
    forceSSL = true;

    locations."/".proxyPass = let grafana_cfg = config.services.grafana.settings.server;  in "http://${grafana_cfg.http_addr}:${toString grafana_cfg.http_port}";
  };
}
