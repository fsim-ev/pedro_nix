{
  config,
  ...
}:{
  services.strichliste = {
    enable = true;

    databaseDir = "/var/lib/strichliste/db";
  };

  services.nginx.virtualHosts."strichliste.fsim-ev.de" = {
    forceSSL = true;
    enableACME = true;

    locations."/" = {
      proxyPass = "http://localhost:${toString config.services.strichliste.port}";
      extraConfig = ''
        allow 172.20.36.242/32; # fsim-room
        allow 10.0.0.0/8; # basically all wifi
        deny all; # no traffic from the outside world
      '';
    };
  };
}
