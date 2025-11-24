{
  config,
  lib,
  pkgs,
  ...
}:
{
  services.postgresql = {
    enable = true;
    package = pkgs.postgresql_14;
    ensureDatabases = [
      config.services.nextcloud.config.dbname
      config.services.hedgedoc.settings.db.database
      config.services.wiki-js.settings.db.db
    ];
    ensureUsers = [
      {
        name = config.services.nextcloud.config.dbuser;
        ensureDBOwnership = true;
      }
      {
        name = config.services.hedgedoc.settings.db.username;
        ensureDBOwnership = true;
      }
      {
        name = config.services.wiki-js.settings.db.db;
        ensureDBOwnership = true;
      }
    ];
    settings = {

      log_min_duration_statement = 1000;
      log_min_messages = "LOG";
      #log_statement = "mod";
      log_destination = lib.mkForce "syslog";
      max_connections = 1024;
      #log_connections = true;

      # Based on https://www.pgconfig.org/#/?max_connections=256&pg_version=14&environment_name=WEB&total_ram=64&cpus=8&drive_type=HDD&arch=x86-64&os_type=linux
      # Memory
      shared_buffers = "16GB";
      effective_cache_size = "48GB";
      work_mem = "64MB";
      maintenance_work_mem = "4GB";
      # Checkpoint related
      min_wal_size = "2GB";
      max_wal_size = "3GB";
      # Storage
      random_page_cost = 5;
      effective_io_concurrency = 2;
    };
  };
}
