{
  lib,
  config,
  pkgs,
  ...
}:{
  age.secrets = {
    zulip-env-file = {
      file = ../secrets/zulip-env-file.age;
    };

    zulip-db-env-file = {
      file = ../secrets/zulip-db-env-file.age;
    };

    zulip-rabbitmq-conf-file = {
      file = ../secrets/zulip-rabbitmq-env-file.age;
    };
  };

  virtualisation.oci-containers.containers = rec {
    chat = {
      image = "zulip/docker-zulip:8.4-0";
      dependsOn = [ "chat-db" "chat-cache" "chat-mqueue" ];
      # hack
      cmd = [ "/bin/sh" "-c" "/home/zulip/deployments/current/scripts/zulip-puppet-apply -f && entrypoint.sh app:run" ];
      # environmentFiles = [ config.age.secrets.zulip-env-file.path ];
      environment = {
        MANUAL_CONFIGURATION = "true";
        #LINK_SETTINGS_TO_DATA = "true";

        # Zulip being retarded...
        SETTING_EXTERNAL_HOST = "chat.fsim-ev.de";
        SETTING_ZULIP_ADMINISTRATOR = "fachschaft_im@oth-regensburg.de";
        SSL_CERTIFICATE_GENERATION = "self-signed";

        SECRETS_postgres_password = lib.fileContents ../secrets/secrets/zulip-db-pass;
        SECRETS_redis_password = lib.last (lib.splitString " " (lib.fileContents ../secrets/secrets/zulip-redis.conf));
        SECRETS_rabbitmq_password = lib.fileContents ../secrets/secrets/zulip-mq-pass;
      };
      volumes = [
        "/var/lib/zulip:/data"
        "/var/log/zulip:/var/log/zulip"
        (toString ./zulip/zulip.conf + ":/etc/zulip/zulip.conf")
        (toString ./zulip/settings.py + ":/etc/zulip/settings.py")
        (toString ../secrets/secrets/zulip + ":/etc/zulip/zulip-secrets.conf")
      ];
      extraOptions = [ "--network=container:chat-db" ];
    };
    chat-db = {
      image = "zulip/zulip-postgresql:14";
      environmentFiles = [ config.age.secrets.zulip-db-env-file.path ];
      environment = {
        POSTGRES_DB = "zulip";
        POSTGRES_USER = "zulip";
      };
      volumes = [
        "/var/lib/zulip/postgresql/data:/var/lib/postgresql/data:rw"
      ];
      ports = [ "8001:80" ]; # for 'chat' container
    };
    chat-cache = {
      image = "redis:alpine";
      dependsOn = [ "chat-db" ];
      cmd = [ "/etc/redis.conf" ];
      volumes = [
        "/var/lib/zulip/redis:/data:rw"
        (toString ../secrets/secrets/zulip-redis.conf + ":/etc/redis.conf")
      ];
      extraOptions = [ "--network=container:chat-db" ];
    };
    chat-mqueue = {
      image = "rabbitmq:4.0.3";
      dependsOn = [ "chat-db" ];
      # environmentFiles = [ config.age.secrets.zulip-rabbitmq-conf-file.path ];
      environment = {
        RABBITMQ_DEFAULT_USER = "zulip";
        RABBITMQ_DEFAULT_PASS = lib.fileContents ../secrets/secrets/zulip-mq-pass;
      };
      volumes = [
        "/var/lib/zulip/rabbitmq:/var/lib/rabbitmq:rw"
      ];
      extraOptions = [ "--network=container:chat-db" ];
    }; 
  };

  services.nginx.virtualHosts."chat.fsim-ev.de" = {
    forceSSL = true;
    enableACME = true;

    locations."/".proxyPass = "http://localhost:8001";
  };
}
