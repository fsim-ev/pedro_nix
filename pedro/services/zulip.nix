{
  lib,
  config,
  pkgs,
  inputs,
  ...
} : let
  image_name = inputs.docker-tag-zulip.image."zulip/docker-zulip".name;
  image_tag = inputs.docker-tag-zulip.image."zulip/docker-zulip".tag;
in {
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

    zulip-secrets = {
      file = ../secrets/zulip-secrets.age;
      group = "wheel";
      mode = "a+r"; #FIXME this shoudl be more granular
    };
    zulip-redis = {
      file = ../secrets/zulip-redis.age;
      group = "wheel";
      mode = "a+r"; #FIXME this shoudl be more granular
    };
  };

  virtualisation.oci-containers.containers = rec {
    chat = {
      image = "${image_name}:${image_tag}";
      dependsOn = [ "chat-db" "chat-cache" "chat-mqueue" ];
      # hack
      cmd = [ "/bin/sh" "-c" "/home/zulip/deployments/current/scripts/zulip-puppet-apply -f && entrypoint.sh app:run" ];
      environmentFiles = [ config.age.secrets.zulip-env-file.path ];
      environment = {
        MANUAL_CONFIGURATION = "true";
        #LINK_SETTINGS_TO_DATA = "true";

        # Zulip being retarded...
        SETTING_EXTERNAL_HOST = "chat.fsim-ev.de";
        SETTING_ZULIP_ADMINISTRATOR = "fachschaft_im@oth-regensburg.de";
        SSL_CERTIFICATE_GENERATION = "self-signed";
      };
      volumes = [
        "/var/lib/zulip:/data"
        "/var/log/zulip:/var/log/zulip"
        "${./zulip/zulip.conf}:/etc/zulip/zulip.conf"
        "${./zulip/settings.py}:/etc/zulip/settings.py"
        "${config.age.secrets.zulip-secrets.path}:/etc/zulip/zulip-secrets.conf"
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
        "${config.age.secrets.zulip-redis.path}:/etc/redis.conf"
      ];
      extraOptions = [ "--network=container:chat-db" ];
    };
    chat-mqueue = {
      image = "rabbitmq:4.0.3";
      dependsOn = [ "chat-db" ];
      # environmentFiles = [ config.age.secrets.zulip-rabbitmq-conf-file.path ];
      environment = {
        RABBITMQ_DEFAULT_USER = "zulip";
        # no touchey, didn't get the env file to work
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
