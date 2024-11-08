{
  pkgs,
  ...
}:{
  users.users = {
    beo45216 = {
      isNormalUser = true;
      shell = pkgs.nushell;
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIR6P1wjKP9IfEki24GKUn3ttOQvsK8qrTNTA6BQhK6R ole@wattson"
      ];
      extraGroups = [ "wheel" "nextcloud" ];
      initialPassword = "changeme";
    };

    laq33610 = {
      isNormalUser = true;
      shell = pkgs.bash;
      openssh.authorizedKeys.keys = [
      	"ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIG+C5UUTDyBZSpBdwY9J3ka3xB6QBume08g9493UfVvl windowsMain"
      	"ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFJAS3KXEQoQp0C0c2sZNVwYu+yUoo43doN1hFyKTBCi archMain"
      ];
      extraGroups = [ "wheel" "nextcloud" ];
      initialPassword = "changeme";
    };

    uta36888 = {
      isNormalUser = true;
      shell = pkgs.fish;
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFmLpfmWBpi1ACI7q/9Rr6QNjy2ntvYRrvIcoXiTleMi engi"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKy1pBbnSgIihWZg4PozI26NUTARrBVrziaV2fXNNZY9 hyperspace"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBxvuuNWDRxO3LuyQX2MaD2NYygqWN5wMVCClSPb4M0Q base"
      ];
      extraGroups = [ "wheel" "nextcloud" ];
      initialPassword = "changeme";
    };

    hoh47200 = {
      isNormalUser = true;
      extraGroups = [ "nextcloud" "wheel" ];
      shell = pkgs.zsh;
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIESektBIV5CX5KuloRo5jytU8dM7PCpPmpHm2ER4Sm8X"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJ0mZ8QVEmhcLjPl55dKt0hAFErrQit3qj3bH/MIEgLn"
      ];
      initialPassword = "changeme";
    };

    scj35826 = {
      isNormalUser = true;
      extraGroups = [ "nextcloud" "wheel" ];
      shell = pkgs.bash;
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICyRU0hL0UOJRJXZZw7ahwDlxlRiy4ULiIouVJKnvHR3"
      ];
      initialPassword = "changeme";
    };
  };
}
