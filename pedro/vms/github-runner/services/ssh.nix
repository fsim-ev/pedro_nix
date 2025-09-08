{
  ...
}:{
    services.openssh = {
      enable = true;

      settings = {
        PermitRootLogin = "yes";
        PasswordAuthentication = false;
      };
    };

    users.users.root.openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHCZSVF6GnRarMgJ5yCv7fBDPQCnqvBJutyJF4KSDNz4 root@pedro"
    ];
  }
