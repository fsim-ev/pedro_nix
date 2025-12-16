{
  config,
  stable,
  ...
}:
{
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
    package = stable.open-webui;
    host = "localhost";
    port = 16753;
    environment = {
      ENABLE_PERSISTENT_CONFIG = "False";
      ANONYMIZED_TELEMETRY = "False";
      DO_NOT_TRACK = "True";
      SCARF_NO_ANALYTICS = "True";
      # BYPASS_MODEL_ACCESS_CONTROL = "True";
      WEBUI_URL = "https://ai.fsim-ev.de";
      # ENABLE_SIGNUP = "False";
      # ENABLE_LDAP = "True";
      # LDAP_SERVER_LABEL = "Authentik LDAP";
      # LDAP_SERVER_HOST = "idp.fsim-ev.de";
      # LDAP_SERVER_PORT = "6636";
      # LDAP_USE_TLS = "True";
      # LDAP_VALIDATE_CERT = "True";
      # LDAP_APP_DN = "cn=openwebui-ldap-user,ou=users,dc=ldap,dc=fsim";
      # LDAP_SEARCH_BASE = "dc=ldap,dc=fsim";
      # LDAP_ATTRIBUTE_FOR_USERNAME = "kennung";
      # LDAP_SEARCH_FILTER = "(&(department=IM)(title=Student))";

      # ENABLE_LDAP_GROUP_MANAGEMENT = "True";
      # ENABLE_LDAP_GROUP_CREATION = "True";

      ENABLE_OAUTH_PERSISTENT_CONFIG = "False";
      ENABLE_OAUTH_SIGNUP = "True";
      OAUTH_MERGE_ACCOUNTS_BY_EMAIL = "True";
      OPENID_PROVIDER_URL = "https://idp.fsim-ev.de/application/o/open-web-ui/.well-known/openid-configuration";
      OAUTH_PROVIDER_NAME = "Authentik";
      OAUTH_SCOPES = "openid email profile groups openwebui";
      OAUTH_ROLES_CLAIM = "roles";
      ENABLE_OAUTH_ROLE_MANAGEMENT = "True";
      OAUTH_ADMIN_ROLES = "OpenWebUI-Admin";
      OPENID_REDIRECT_URI = "https://ai.fsim-ev.de/oauth/oidc/callback";
      ENABLE_LOGIN_FORM = "False";
      OAUTH_GROUP_CLAIM = "groups";
      

      DEFAULT_USER_ROLE = "user";
      ENABLE_ADMIN_CHAT_ACCESS = "False";
      ENABLE_ADMIN_EXPORT = "False";
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
