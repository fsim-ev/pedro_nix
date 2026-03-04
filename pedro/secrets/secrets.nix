let
  system = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOG9ZGIyV8MMQVmQ9dnAnolXsVrxE0kKFdY86i6jba6E root@nixos";

  root = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHCZSVF6GnRarMgJ5yCv7fBDPQCnqvBJutyJF4KSDNz4 root@pedro";

  system_toast = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAOAGS7JYMzJRAap5d4+43NO+i69BXFDWK4yF+tc+CTp root@toast";

  authed = [
    system
    system_toast
    root
  ];
in
{
  "nextcloud-admin-pass.age".publicKeys = authed;

  "hedgedoc-env-file.age".publicKeys = authed;

  "zulip-env-file.age".publicKeys = authed;
  "zulip-db-env-file.age".publicKeys = authed;
  "zulip-rabbitmq-env-file.age".publicKeys = authed;
  "zulip-secrets.age".publicKeys = authed;
  "zulip-redis.age".publicKeys = authed;

  "wiki-js-env-file.age".publicKeys = authed;

  "open-webui-env-file.age".publicKeys = authed;

  "paperless-ngx-admin.age".publicKeys = authed;
  "paperless-ngx-oidc.age".publicKeys = authed;

  "wireguard-priv-key-proxy-ole.age".publicKeys = authed;

  "wireguard-key-fsim-room-tunnel.age".publicKeys = authed;

  "renovate-bot-token.age".publicKeys = authed;
  "renovate-github-token.age".publicKeys = authed;
  "gitlab-runner-token.age".publicKeys = authed;

  "keycloak-db-pass.age".publicKeys = authed;

  "authentik-env.age".publicKeys = authed;
  "authentik-ldap-env.age".publicKeys = authed;

  "engelsystem-sso-client-id.age".publicKeys = authed;
  "engelsystem-sso-client-secret.age".publicKeys = authed;

  "grafana-sso-client-id.age".publicKeys = authed;
  "grafana-sso-client-secret.age".publicKeys = authed;

  "opnform-pg-env.age".publicKeys = authed;
  "opnform-api-env.age".publicKeys = authed;
  "opnform-client-env.age".publicKeys = authed;

  "grafana-secret-key.age".publicKeys = authed;

  "vaultwarden-env.age".publicKeys = authed;
}
