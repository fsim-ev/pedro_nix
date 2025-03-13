{
  pkgs,
  ...
}:{
  users.users = {
    beo45216 = {
      isNormalUser = true;
      shell = pkgs.nushell;
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIR6P1wjKP9IfEki24GKUn3ttOQvsK8qrTNTA6BQhK6R wattson"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGKUAOne60N9LZ1PbTQgjzrtQoW+m+7OaEWTHzprIczc main"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIH2oTtiXMyuSFiAwGF2s29J7ShRTXqST6Uxc+obT0Y+u kartoffelkiste"
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
      ];
      initialPassword = "changeme";
    };

     mat36812 = {
      isNormalUser = true;
      extraGroups = [ "nextcloud" "wheel" ];
      shell = pkgs.zsh;
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICtXCEbcXriOx+oyFr+j4ozhrFMEqxDvcj1zZUthjKV0"
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

    remote-builder = {
      isNormalUser = true;

      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFrLa7hKhD0yo17zxeyEbwLgz5VQYwPSqALZqpPXY+f5 ole"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAID2A+6WAfGhy5xd4jHcCg7bTh2IFIQO3nlpfrY3/l84u leo@lpl"
      ];
    };
  };
}
