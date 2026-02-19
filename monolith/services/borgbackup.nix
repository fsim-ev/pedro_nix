{...}:{
  # Backup service
  services.borgbackup.repos = {
    "infra-examia" = {
      authorizedKeysAppendOnly = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBxGYg/SMtF/fb79pZQMN0UC3t1R7/HSqXuD0IbKtzYV root@ori"
      ];
      path = "/mnt/storage/backup/infra/examia";
      user = "examia";
      quota = "200G";
    };
    "infra-zulip" = {
      authorizedKeysAppendOnly = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBxGYg/SMtF/fb79pZQMN0UC3t1R7/HSqXuD0IbKtzYV root@ori"
      ];
      path = "/mnt/storage/backup/infra/zulip";
      user = "zulip";
      quota = "100G";
    };
    "infra-nextcloud" = {
      authorizedKeysAppendOnly = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBxGYg/SMtF/fb79pZQMN0UC3t1R7/HSqXuD0IbKtzYV root@ori"
      ];
      path = "/mnt/storage/backup/infra/nextcloud";
      user = "nextcloud";
      quota = "1024G";
    };
    "infra-hedgedoc" = {
      authorizedKeysAppendOnly = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBxGYg/SMtF/fb79pZQMN0UC3t1R7/HSqXuD0IbKtzYV root@ori"
      ];
      path = "/mnt/storage/backup/infra/hedgedoc";
      user = "hedgedoc";
      quota = "10G";
    };

    "game-minecraft" = {
      authorizedKeysAppendOnly = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBxGYg/SMtF/fb79pZQMN0UC3t1R7/HSqXuD0IbKtzYV root@ori"
      ];
      path = "/mnt/storage/backup/infra/minecraft";
      user = "minecraft";
      quota = "100G";
    };
  };
}
