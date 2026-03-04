let
  autologin = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICRXgdZJXQosB/6k9imeNRPhO/+bUY6jOzUcU0nOR4sf autologin@apollo";
  pedro_root = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHCZSVF6GnRarMgJ5yCv7fBDPQCnqvBJutyJF4KSDNz4 root@pedro";
  authed = [
    autologin
    pedro_root
  ];
in
{
  "stundenplan-toml.age".publicKeys = authed;
  "todo-toml.age".publicKeys = authed;
}
