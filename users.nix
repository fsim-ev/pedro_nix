{
  pkgs,
  ...
}:{
  users.users = {
    beo45216 = {
      isNormalUser = true;
      shell = pkgs.bash;
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIR6P1wjKP9IfEki24GKUn3ttOQvsK8qrTNTA6BQhK6R ole@wattson"
      ];
      extraGroups = [ "wheel" ];
      initialPassword = "changeme";
    };

    laq33610 = {
      isNormalUser = true;
      shell = pkgs.bash;
      openssh.authorizedKeys.keys = [
      	"ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIG+C5UUTDyBZSpBdwY9J3ka3xB6QBume08g9493UfVvl windowsMain"
      	"ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFJAS3KXEQoQp0C0c2sZNVwYu+yUoo43doN1hFyKTBCi archMain"
      ];
      extraGroups = [ "wheel" ];
      initialPassword = "changeme";
    };
  };
}
