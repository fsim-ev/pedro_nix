{
  config,
  ...
}:{
  services.strichliste = {
    enable = true;

    frontEnd = builtins.fetchTarball {
      url = "https://git.ole.blue/ole/strichliste-frontend/raw/commit/07433011ebc3c30741de2946079b5a1ac71f8f0e/build.tar";
      sha256 = "181ds9c22r8618ylk4fbsnbvqzxzplr16s3vx56yp5f4lidl79w7";
    };

    nginxSettings = {
      configure = true;
      domain = "strichliste.fsim-ev.de";
    };

    databaseUrl = "mysql://strichliste@localhost/strichliste";

    settings = {
      payment.boundary.upper = 200000;
      account.boundary.upper = 200000;

      article.autoOpen = true;
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

    locations."/api/metrics" = {
      extraConfig = ''
        deny all;
      '';
    };


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
      {
        name = "grafana";
        ensurePermissions = {
          "strichliste.*" = "SELECT";
        };
      }
    ];

    ensureDatabases = [
      "strichliste"
    ];
  };
}
