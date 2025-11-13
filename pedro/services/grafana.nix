{
  config,
  pkgs,
  ...
}:
{
  services.grafana = {
    enable = true;

    declarativePlugins = with pkgs.grafanaPlugins; [
      frser-sqlite-datasource
    ];

    settings = {
      server = {
        http_addr = "127.0.0.1";
        http_port = 45128;

        domain = "stats.fsim-ev.de";
      };

      analytics.reporting_enabled = false;
    };
  };

  systemd.services."grafana.service".serviceConfig.ReadWritePaths = [
    "/var/lib/strichliste-rs/database.db"
  ];

  services.nginx.virtualHosts."${config.services.grafana.settings.server.domain}" = {
    enableACME = true;
    forceSSL = true;

    locations."/".proxyPass =
      let
        grafana_cfg = config.services.grafana.settings.server;
      in
      "http://${grafana_cfg.http_addr}:${toString grafana_cfg.http_port}";
  };

}
