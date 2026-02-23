{ pkgs, ... }:
{

  users.users = {
    root.openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHCZSVF6GnRarMgJ5yCv7fBDPQCnqvBJutyJF4KSDNz4 root@pedro"
    ];
    hoh47200 = {
      isNormalUser = true;
      description = "hoh47200";
      extraGroups = [
        "networkmanager"
        "wheel"
      ];
      packages = with pkgs; [ ];
    };

    beo45216 = {
      isNormalUser = true;
      extraGroups = [
        "networkmanager"
        "wheel"
      ];
      initialPassword = "changeme";
    };

    autologin = {
      isNormalUser = true;
    };
  };
}
