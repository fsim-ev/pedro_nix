let
  root = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHCZSVF6GnRarMgJ5yCv7fBDPQCnqvBJutyJF4KSDNz4 root@pedro";

  vm = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAII0xbmlJtnb6ey6DWFIaafOK0QFqua0F700ZcuAjmcb2 root@pedro";

  authed = [
    root
    vm
  ];

in
{
  "forgejo-access-token.age".publicKeys = authed;
}
