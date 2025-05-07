{
  inputs,
  config,
  ...
}:{

  users.groups.nginx.members = [ "anubis" ];
  
  services.anubis = {
    defaultOptions = {
      user = "anubis";
      # group = "anubis";
      settings = {
        SERVE_ROBOTS_TXT = true;
        BIND_NETWORK = "tcp";
      };
    };

    instances.homepage = {
      enable = true;
      settings = {
        TARGET = "unix:///run/nginx/nginx.sock";
        # SOCKET_MODE = "0660";
        BIND = ":8785";
      };
    };
  };

  # This is needed for nginx to be able to read other processes
  # directories in `/run`. Else it will fail with (13: Permission denied)
  systemd.services.nginx.serviceConfig.ProtectHome = false;
  
  services.nginx.virtualHosts = let
    aliases = ["beta.fsim-ev.de" "www.fsim-ev.de" ];
  in {

    "fsim-ev.de-frontend" = {
      forceSSL = true;
      enableACME = true;

      serverName = "fsim-ev.de";
      serverAliases = aliases;

      locations."/".proxyPass = "http://localhost${config.services.anubis.instances.homepage.settings.BIND}/";
    };
    
    "fsim-ev.de-unix" = {
      serverName = "fsim-ev.de";
      serverAliases = aliases;
      listen = [
        {
          addr = "unix:/run/nginx/nginx.sock";
        }
      ];
      locations."/".root = inputs.website.packages.x86_64-linux.default;
    };
  };
}
