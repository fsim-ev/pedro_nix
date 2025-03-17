{
  config,
  ...
}:{
  age.secrets = {
    open-webui-env-file = {
      file = ../secrets/open-webui-env-file.age;
    };
  };

  nixpkgs.config.allowUnfree = true;
  
  services.ollama = {
    enable = true;
    acceleration = "cuda";
  };

  services.open-webui = {
    enable = true;
    environmentFile = config.age.secrets.open-webui-env-file.path;
    host = "localhost";
    port = 16753;
  };

  services.nginx.virtualHosts = {
    "ai.fsim-ev.de" = {
      locations."/" = {
        proxyWebsockets = true;
        proxyPass = "http://localhost:${builtins.toString config.services.open-webui.port}";
      };
      forceSSL = true;
      enableACME = true;
      extraConfig = ''
        proxy_busy_buffers_size 512k;
        proxy_buffers 4 512k;
        proxy_buffer_size 256k;
      '';
    };
  };
}
