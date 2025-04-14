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
    environment = {
      ENABLE_SIGNUP = "False";
      ENABLE_OAUTH_SIGNUP = "True";
      OAUTH_PROVIDER_NAME = "Nextcloud";
      OAUTH_SCOPES = "openid email roles profile";
      ENABLE_OAUTH_ROLE_MANAGEMENT = "True";
      OAUTH_USERNAME_CLAIM = "name";
      OAUTH_EMAIL_CLAIM = "email";
      OAUTH_PICTURE_CLAIM = "picture";
      OAUTH_ROLES_CLAIM = "roles";
      OAUTH_ALLOWED_ROLES = "IM_Studenten";
      OAUTH_ADMIN_ROLES = "admin,IM_Fachschaft_Administratoren";
      OPENID_PROVIDER_URL = "https://cloud.fsim-ev.de/index.php/.well-known/openid-configuration";
      OAUTH_MERGE_ACCOUNTS_BY_EMAIL = "False";
      ANONYMIZED_TELEMETRY = "False";
      DO_NOT_TRACK = "True";
      SCARF_NO_ANALYTICS = "True";
      BYPASS_MODEL_ACCESS_CONTROL = "True";
    }; 

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
