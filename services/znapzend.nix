{
  ...
}:{
  services.znapzend = {
    enable = true;
    pure = true;
    autoCreation = true;
    features.skipIntermediates = true;
    zetup = let
      defaultRemote = {
        host = "root@fren.fsim";
        dataset = "storage/new-backup";
      };
    in {
      "storage/services" = {
        plan = "1m=>1d";
        recursive = true;

        destinations.remote = defaultRemote;
      };

      "storage/services/strichliste" = {
        plan = "10d=>1h";
        dataset = "storage/new-backup";

        destinations.remote = defaultRemote;
      };
    };
  };
}
