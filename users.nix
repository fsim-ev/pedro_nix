{
  ...
}:{
  users.users = {
    beo45216 = {
      isNormalUser = true;
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIR6P1wjKP9IfEki24GKUn3ttOQvsK8qrTNTA6BQhK6R ole@wattson"
      ];
      extraGroups = [ "wheel" ];
      initialPassword = "changeme";
    };
  };
}
