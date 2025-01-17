{
  config,
  ...
}:{
  services.strichliste = {
    enable = true;

    databaseDir = "/var/lib/strichliste/db";

    settings = {
      payment.boundary.upper = 200000;
      account.boundary.upper = 200000;
    };
  };

  services.nginx.virtualHosts =
  let
    host =  {
      forceSSL = true;
      enableACME = true;

      locations = {
        
        "/" = {
          proxyPass = "http://localhost:${toString config.services.strichliste.port}";
          extraConfig = ''
            allow 172.20.36.242/32;
            # allow 172.16.0.0/16;
            # allow 10.0.0.0/8;
            deny all; # no traffic from the outside world

            error_page 403 @custom403;
          '';
        };

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
  in
  {
    "strichliste.fsim-ev.de" = host;
    "mate.fsim-ev.de" = host;
  };
}
