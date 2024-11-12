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
      locations."/".proxyPass = "http://localhost:${builtins.toString config.services.open-webui.port}";
      forceSSL = true;
      enableACME = true;
    };
  };
}
