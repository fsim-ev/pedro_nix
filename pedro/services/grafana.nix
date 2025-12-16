{
  config,
  pkgs,
  ...
}:
{
  age.secrets = {
    grafana-sso-client-id = {
      file = ../secrets/grafana-sso-client-id.age;
      owner = "grafana";
      group = "grafana";
    };
    grafana-sso-client-secret = {
      file = ../secrets/grafana-sso-client-secret.age;
      owner = "grafana";
      group = "grafana";
    };
  };
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
        root_url = "https://stats.fsim-ev.de";
      };

      analytics.reporting_enabled = false;

      "auth.generic_oauth" = {
        enabled = true;
        name = "Authentik";
        client_id = "$__file{${config.age.secrets.grafana-sso-client-id.path}}";
        client_secret = "$__file{${config.age.secrets.grafana-sso-client-secret.path}}";
        auth_url = "https://idp.fsim-ev.de/application/o/authorize/";
        token_url = "https://idp.fsim-ev.de/application/o/token/";
        api_url = "https://idp.fsim-ev.de/application/o/userinfo/";
        scopes = [
          "openid"
          "email"
          "profile"
        ];
        login_attribute_path = "nickname";
        groups_attribute_path = "groups";
        allow_assign_grafana_admin = true;
        role_attribute_path = "contains(groups, 'Grafana-Admin') && 'GrafanaAdmin' || 'Viewer'";
        auto_login = true; # temporarily disable with '/login?disableAutoLogin=true'
      };
    };
  };

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
