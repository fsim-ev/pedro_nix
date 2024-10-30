{
  config,
  ...
}:{
  age.secrets = {
    wiki-js-env-file = {
      file = ../secrets/wiki-js-env-file.age;
    };
  };

  services.wiki-js = {
    enable = true;
    settings = {
      bindIP = "127.0.0.1";
      port = 8002;

      db.host = "localhost";
      db.pass = "$(DB_PASS)";
      db.db = "wiki";
      db.user = "wiki";

      #logLevel = "silly";
    };
    environmentFile = config.age.secrets.wiki-js-env-file.path;
  };

  services.nginx.virtualHosts."wiki.fsim-ev.de" = {
    forceSSL = true;
    enableACME = true;

    locations."/".proxyPass = "http://localhost:${builtins.toString config.services.wiki-js.settings.port}";
  };
}
