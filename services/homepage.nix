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
  
  services.nginx.virtualHosts = {

    "beta.fsim-ev.de-frontend" = {
      forceSSL = true;
      enableACME = true;

      serverName = "beta.fsim-ev.de";

      locations."/".proxyPass = "http://localhost${config.services.anubis.instances.homepage.settings.BIND}/";
    };
    
    "beta.fsim-ev.de-unix" = {
      serverName = "beta.fsim-ev.de";
      listen = [
        {
          addr = "unix:/run/nginx/nginx.sock";
        }
      ];
      locations."/".root = inputs.website.packages.x86_64-linux.default;
    };
  };
}
