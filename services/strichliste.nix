{
  config,
  ...
}:{
  services.strichliste = {
    enable = true;

    nginxSettings = {
      configure = true;
      domain = "strichliste.fsim-ev.de";
    };

    databaseUrl = "mysql://strichliste@localhost/strichliste";

    settings = {
      payment.boundary.upper = 200000;
      account.boundary.upper = 200000;
    };
  };

  services.nginx.virtualHosts.${config.services.strichliste.nginxSettings.domain} = {
    forceSSL = true;
    enableACME = true;

    locations."/".extraConfig = ''
      allow 172.20.36.242/32;
      deny all;

      error_page 403 @custom403;
    '';

    locations = {
      "@custom403" = {
        extraConfig = ''
          default_type text/html;
          return 200 '<html>
          <head><title>403 Forbidden</title></head>
          <body>
            <h1>Du musst leider in die Fachschaft kommen, um abzurechnen.</h1>
          </body>
          </html>';
        '';
      };
    };
  };

  services.mysql = {

    ensureUsers = [
      {
        name = "strichliste";
        ensurePermissions = {
          "strichliste.*" = "ALL PRIVILEGES";
        };
      }
    ];

    ensureDatabases = [
      "strichliste"
    ];
  };

  users = {
    users.strichliste = {
      isSystemUser = true;
      group = "strichliste";
    };

    groups.strichliste = {};
  };
}
