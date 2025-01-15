{
  ...
}:{
  services.znapzend = {
    enable = true;
    pure = true;
    autoCreation = true;
    features.skipIntermediates = true;
    zetup = {
      "storage/services" = {
        plan = "1m=>1d";
        recursive = true;

        destinations.remote = {
          host = "root@fren.fsim";
          dataset = "storage/new-backup";
          # presend = "zfs mount -R storage/backup";
        };
      };

      "storage/services/strichliste" = {
        plan = "10d=>1h";
        dataset = "storage/new-backup";
      };
    };
  };
}
