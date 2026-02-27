{
  config,
  ...
}:
let
  domain = "documents.fsim-ev.de";
in
{
  age.secrets = {
    paperless-ngx-admin.file = ../secrets/paperless-ngx-admin.age;
    paperless-ngx-oidc.file = ../secrets/paperless-ngx-oidc.age;
  };

  services.paperless = {
    enable = true;

    inherit domain;

    dataDir = "/var/lib/paperless";

    settings = {
      PAPERLESS_URL = "https://${domain}";
      PAPERLESS_LOGOUT_REDIRECT_URL = "https://idp.fsim-ev.de/application/o/paperless/end-session/";
      PAPERLESS_AUTO_LOGIN = true;
      PAPERLESS_AUTO_CREATE = true;
      PAPERLESS_SOCIAL_AUTO_SIGNUP = true;
      PAPERLESS_SOCIALACCOUNT_ALLOW_SIGNUPS = true;
      PAPERLESS_APPS="allauth.socialaccount.providers.openid_connect";
      PAPERLESS_SOCIAL_ACCOUNT_SYNC_GROUPS = true;
    };

    passwordFile = config.age.secrets.paperless-ngx-admin.path;

    environmentFile = config.age.secrets.paperless-ngx-oidc.path;
  };

  services.nginx.virtualHosts."${domain}" = {
    enableACME = true;
    forceSSL = true;

    locations."/".proxyPass =
      "http://${config.services.paperless.address}:${toString config.services.paperless.port}";
  };
}
