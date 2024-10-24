let 
  system = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOG9ZGIyV8MMQVmQ9dnAnolXsVrxE0kKFdY86i6jba6E root@nixos";

  beo45216 = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKnBjkICd0zMKGsZNSXbe7quhU5CbL/ReT0pooY+pPcJ beo45216@pedro";

  authed = [ system beo45216 ];
in {
  "nextcloud-admin-pass.age".publicKeys = authed;
}
