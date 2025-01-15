{
  config,
  ...
}:{
  services.strichliste = {
    enable = true;

    databaseDir = "/var/lib/strichliste/db";
  };

  services.nginx.virtualHosts =
  let
    host =  {
      forceSSL = true;
      enableACME = true;

      locations."/" = {
        proxyPass = "http://localhost:${toString config.services.strichliste.port}";
        extraConfig = ''
          allow 172.20.36.242/32;
          allow 172.16.0.0/16;
          allow 10.0.0.0/8;
          deny all; # no traffic from the outside world
        '';
      };
    };
  in
  {
    "strichliste.fsim-ev.de" = host;
    "mate.fsim-ev.de" = host;
  };
}
