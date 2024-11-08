let 
  system = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOG9ZGIyV8MMQVmQ9dnAnolXsVrxE0kKFdY86i6jba6E root@nixos";

  root = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHCZSVF6GnRarMgJ5yCv7fBDPQCnqvBJutyJF4KSDNz4 root@pedro";

  beo45216 = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKnBjkICd0zMKGsZNSXbe7quhU5CbL/ReT0pooY+pPcJ beo45216@pedro";

  laq33610 = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJiYDGbWQnyaL0+U1BmLKGn7yqRtdaQOAjXSBkejDycH laq33610@pedro";

  authed = [ system root beo45216 laq33610 ];
in {
  "nextcloud-admin-pass.age".publicKeys = authed;

  "hedgedoc-env-file.age".publicKeys = authed;

  "zulip-env-file.age".publicKeys = authed;
  "zulip-db-env-file.age".publicKeys = authed;
  "zulip-rabbitmq-env-file.age".publicKeys = authed;

  "wiki-js-env-file.age".publicKeys = authed;

  "openwebui-env-file.age".publicKeys = authed;
}
