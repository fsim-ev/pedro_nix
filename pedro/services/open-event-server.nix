{
  ...
}:
let
  serverStorageDir = "/var/lib/open-event-server/server";
in {
  virtualisation.oci-containers.containers = rec {
    opev-postgres = {
      image = "postgis/postgis:12-3.0-alpine";

      volumes = [
        "${serverStorageDir}/pg:/var/lib/postgresql/data"
      ];

      environment = {
        POSTGRES_USER = "open_event_user";
        POSTGRES_PASSWORD = "open_event_user";
        POSTGRES_DB = "open_event";
      };

      ports = [
        "8004:8080"
        "8005:4000"
      ];
    };

    opev-redis = {
      image = "redis:3-alpine";
      entrypoint = "redis-server";
      volumes = [
        "${serverStorageDir}/redis:/var/lib/redis/data"
      ];

      extraOptions = [ "--network=container:opev-postgres" ];
    };

    opev-web = {
      image = "eventyay/open-event-server:development";

      dependsOn = [
        "opev-redis"
        "opev-postgres"
      ];

      environment = {
        POSTGRES_HOST = "postgres";
        DATABASE_URL = "postgresql://open_event_user:open_event_user@127.0.0.1:5432/open_event";
        REDIS_URL = "redis://127.0.0.1:6379/0";
        ADMIN_EMAIL = "fachschaft_im@oth-regensburg.de";
        ADMIN_PASSWORD = "test1234abcd";
        SECRET_KEY = "24d97a4bbeb06e7414a3de529af450ac177bca7f5e2054f923c6f3692f178983";
      };

      volumes = [
        "${serverStorageDir}/static:/data/app/static"
        "${serverStorageDir}/generated:/data/app/generated"
      ];

      extraOptions = [ "--network=container:opev-postgres" ];
    };

    opev-celery = opev-web // {
      dependsOn = [
        "opev-web"
      ];

      environment = opev-web.environment // {
        C_FORCE_ROOT = "true";
      };

      entrypoint = "celery";
    };

    "opev-frontend" = {
      image = "eventyay/open-event-frontend";

      environment = {
        INJECT_ENV = "true";
        FASTBOOT_DISABLED = "true";
        API_HOST = "https://api.events.fsim-ev.de";
        MAP_DISPLAY = "embed";
      };

      extraOptions = [ "--network=container:opev-postgres" ];
    };
  };

  services.nginx.virtualHosts = {
    "api.events.fsim-ev.de" = {
      forceSSL = true;
      enableACME = true;

      locations."/".proxyPass = "http://localhost:8004";
    };

    "events.fsim-ev.de" = {
      forceSSL = true;
      enableACME = true;

      locations."/".proxyPass = "http://localhost:8005";
    };
  };
}
