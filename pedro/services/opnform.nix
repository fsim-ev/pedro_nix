{
  lib,
  pkgs,
  config,
  ...
}:
let
  env-all = {
    "SELF_HOSTED" = "true";
    "OPNFORM_ANONYMOUS_TELEMETRY_DISABLED" = "true";
  };
  api-env-all = env-all // {
    "APP_DEBUG" = "true";
    "APP_ENV" = "production";
    "APP_LOG_LEVEL" = "debug";
    "APP_NAME" = "OpnForm";
    "APP_URL" = "https://forms.fsim-ev.de";
    "AWS_DEFAULT_REGION" = "us-east-1";
    "BROADCAST_CONNECTION" = "log";
    "CACHE_STORE" = "file";
    "CADDY_AUTHORIZED_IPS" = "";
    "FILESYSTEM_DRIVER" = "local";
    "FRONT_URL" = "https://forms.fsim-ev.de";
    "JWT_REMEMBER_TTL" = "43200";
    "JWT_TTL" = "10080";
    "LOG_CHANNEL" = "stack";
    "LOG_LEVEL" = "debug";
    "MAIL_ENCRYPTION" = "null";
    "MAIL_FROM_ADDRESS" = "fachschaft_im@oth-regensburg.de";
    "MAIL_FROM_NAME" = "Fachschaft IM";
    "MAIL_HOST" = "smtp.hs-regensburg.de";
    "MAIL_MAILER" = "smtp";
    "MAIL_PORT" = "25";
    "MAIL_USERNAME" = "fachschaft_im@oth-regensburg.de";
    "MIX_PUSHER_APP_CLUSTER" = "mt1";
    "PHP_MAX_EXECUTION_TIME" = "600";
    "PHP_MEMORY_LIMIT" = "1G";
    "PHP_POST_MAX_SIZE" = "64M";
    "PHP_UPLOAD_MAX_FILESIZE" = "64M";
    "PUSHER_APP_CLUSTER" = "mt1";
    "QUEUE_CONNECTION" = "sync";
    "REDIS_HOST" = "redis";
    "REDIS_PORT" = "6379";
    "RE_CAPTCHA_SECRET_KEY" = "";
    "SESSION_DRIVER" = "file";
    "SESSION_LIFETIME" = "120";
    "STRIPE_PROD_DEFAULT_PRICING_MONTHLY" = "";
    "STRIPE_PROD_DEFAULT_PRICING_YEARLY" = "";
    "STRIPE_PROD_DEFAULT_PRODUCT_ID" = "";
    "STRIPE_TEST_DEFAULT_PRICING_MONTHLY" = "";
    "STRIPE_TEST_DEFAULT_PRICING_YEARLY" = "";
    "STRIPE_TEST_DEFAULT_PRODUCT_ID" = "";
    "TEMPLATE_EDITOR_EMAILS" = "";
    "ZAPIER_ENABLED" = "false";
  };
  client-env-all = env-all // {
    "NUXT_LOG_LEVEL" = "";
    "NUXT_PUBLIC_AMPLITUDE_CODE" = "";
    "NUXT_PUBLIC_API_BASE" = "https://forms.fsim-ev.de/api";
    "NUXT_PUBLIC_APP_URL" = "https://forms.fsim-ev.de";
    "NUXT_PUBLIC_CLARITY_PROJECT_ID" = "";
    "NUXT_PUBLIC_CRISP_WEBSITE_ID" = "";
    "NUXT_PUBLIC_ENV" = "";
    "NUXT_PUBLIC_ROOT_REDIRECT_URL" = "";

  };
  pg-envfile-path = config.age.secrets.opnform-pg-env.path;
  api-envfile-path = config.age.secrets.opnform-api-env.path;
  client-envfile-path = config.age.secrets.opnform-client-env.path;

in
{
  age.secrets = {
    opnform-pg-env.file = ../secrets/opnform-pg-env.age;
    opnform-api-env.file = ../secrets/opnform-api-env.age;
    opnform-client-env.file = ../secrets/opnform-client-env.age;
  };
  # Containers
  virtualisation.oci-containers.containers."opnform-api" = {
    image = "jhumanj/opnform-api:latest";
    environment = api-env-all;
    environmentFiles = [
      api-envfile-path
      pg-envfile-path
    ];
    volumes = [
      "/var/lib/opnform/storage:/usr/share/nginx/html/storage:rw"
    ];
    dependsOn = [
      "opnform-db"
      "opnform-redis"
    ];
    log-driver = "journald";
    extraOptions = [
      # "--health-cmd=php /usr/share/nginx/html/artisan about || exit 1"
      # "--health-interval=30s"
      # "--health-retries=3"
      # "--health-start-period=1m0s"
      # "--health-timeout=15s"
      "--network-alias=api"
      "--network=opnform_default"
    ];
  };
  systemd.services."podman-opnform-api" = {
    serviceConfig = {
      Restart = lib.mkOverride 90 "no";
    };
    after = [
      "podman-network-opnform_default.service"
    ];
    requires = [
      "podman-network-opnform_default.service"
    ];
    partOf = [
      "podman-compose-opnform-root.target"
    ];
    wantedBy = [
      "podman-compose-opnform-root.target"
    ];
  };
  virtualisation.oci-containers.containers."opnform-api-scheduler" = {
    image = "jhumanj/opnform-api:latest";
    environment = api-env-all;
    environmentFiles = [ api-envfile-path ];
    volumes = [
      "/var/lib/opnform/storage:/usr/share/nginx/html/storage:rw"
    ];
    cmd = [
      "php"
      "artisan"
      "schedule:work"
    ];
    dependsOn = [
      "opnform-db"
      "opnform-redis"
    ];
    log-driver = "journald";
    extraOptions = [
      # "--health-cmd=php /usr/share/nginx/html/artisan app:scheduler-status --mode=check --max-minutes=3 || exit 1"
      # "--health-interval=1m0s"
      # "--health-retries=3"
      # "--health-start-period=1m10s"
      # "--health-timeout=30s"
      "--network-alias=api-scheduler"
      "--network=opnform_default"
    ];
  };
  systemd.services."podman-opnform-api-scheduler" = {
    serviceConfig = {
      Restart = lib.mkOverride 90 "no";
    };
    after = [
      "podman-network-opnform_default.service"
    ];
    requires = [
      "podman-network-opnform_default.service"
    ];
    partOf = [
      "podman-compose-opnform-root.target"
    ];
    wantedBy = [
      "podman-compose-opnform-root.target"
    ];
  };
  virtualisation.oci-containers.containers."opnform-api-worker" = {
    image = "jhumanj/opnform-api:latest";
    environment = api-env-all;
    environmentFiles = [ api-envfile-path ];
    volumes = [
      "/var/lib/opnform/storage:/usr/share/nginx/html/storage:rw"
    ];
    cmd = [
      "php"
      "artisan"
      "queue:work"
    ];
    dependsOn = [
      "opnform-db"
      "opnform-redis"
    ];
    log-driver = "journald";
    extraOptions = [
      # "--health-cmd=pgrep -f 'php artisan queue:work' > /dev/null || exit 1"
      # "--health-interval=1m0s"
      # "--health-retries=3"
      # "--health-start-period=30s"
      # "--health-timeout=10s"
      "--network-alias=api-worker"
      "--network=opnform_default"
    ];
  };
  systemd.services."podman-opnform-api-worker" = {
    serviceConfig = {
      Restart = lib.mkOverride 90 "no";
    };
    after = [
      "podman-network-opnform_default.service"
    ];
    requires = [
      "podman-network-opnform_default.service"
    ];
    partOf = [
      "podman-compose-opnform-root.target"
    ];
    wantedBy = [
      "podman-compose-opnform-root.target"
    ];
  };
  virtualisation.oci-containers.containers."opnform-client" = {
    image = "jhumanj/opnform-client:latest";
    environment = client-env-all;
    environmentFiles = [ client-envfile-path ];
    dependsOn = [
      "opnform-api"
    ];
    log-driver = "journald";
    extraOptions = [
      # "--health-cmd=wget --spider -q http://localhost:3000/login || exit 1"
      # "--health-interval=30s"
      # "--health-retries=3"
      # "--health-start-period=45s"
      # "--health-timeout=10s"
      "--network-alias=opnform-client"
      "--network=opnform_default"
    ];
  };
  systemd.services."podman-opnform-client" = {
    serviceConfig = {
      Restart = lib.mkOverride 90 "no";
    };
    after = [
      "podman-network-opnform_default.service"
    ];
    requires = [
      "podman-network-opnform_default.service"
    ];
    partOf = [
      "podman-compose-opnform-root.target"
    ];
    wantedBy = [
      "podman-compose-opnform-root.target"
    ];
  };
  virtualisation.oci-containers.containers."opnform-db" = {
    image = "postgres:16";
    volumes = [
      "/var/lib/opnform/pg:/var/lib/postgresql/data:rw"
    ];
    environmentFiles = [ pg-envfile-path ];
    log-driver = "journald";
    extraOptions = [
      # "--health-cmd=pg_isready -U forge"
      # "--health-interval=30s"
      # "--health-timeout=5s"
      "--network-alias=db"
      "--network=opnform_default"
    ];
  };
  systemd.services."podman-opnform-db" = {
    serviceConfig = {
      Restart = lib.mkOverride 90 "no";
    };
    after = [
      "podman-network-opnform_default.service"
    ];
    requires = [
      "podman-network-opnform_default.service"
    ];
    partOf = [
      "podman-compose-opnform-root.target"
    ];
    wantedBy = [
      "podman-compose-opnform-root.target"
    ];
  };
  virtualisation.oci-containers.containers."opnform-ingress" = {
    image = "nginx:1";
    environment = {
      "NGINX_MAX_BODY_SIZE" = "64m";
    };
    volumes = [
      "${./opnform/nginx.conf}:/etc/nginx/templates/default.conf.template:rw"
    ];
    ports = [
      "3001:80/tcp"
    ];
    dependsOn = [
      "opnform-api"
      "opnform-client"
    ];
    log-driver = "journald";
    extraOptions = [
      # "--health-cmd=nginx -t && curl -f http://localhost/ || exit 1"
      # "--health-interval=30s"
      # "--health-retries=3"
      # "--health-start-period=10s"
      # "--health-timeout=5s"
      "--network-alias=ingress"
      "--network=opnform_default"
    ];
  };
  systemd.services."podman-opnform-ingress" = {
    serviceConfig = {
      Restart = lib.mkOverride 90 "no";
    };
    after = [
      "podman-network-opnform_default.service"
    ];
    requires = [
      "podman-network-opnform_default.service"
    ];
    partOf = [
      "podman-compose-opnform-root.target"
    ];
    wantedBy = [
      "podman-compose-opnform-root.target"
    ];
  };
  virtualisation.oci-containers.containers."opnform-redis" = {
    image = "redis:7";
    volumes = [
      "/var/lib/opnform/redis:/data:rw"
    ];
    log-driver = "journald";
    extraOptions = [
      # "--health-cmd=redis-cli ping | grep PONG"
      # "--health-interval=30s"
      # "--health-timeout=5s"
      "--network-alias=redis"
      "--network=opnform_default"
    ];
  };
  systemd.services."podman-opnform-redis" = {
    serviceConfig = {
      Restart = lib.mkOverride 90 "no";
    };
    after = [
      "podman-network-opnform_default.service"
    ];
    requires = [
      "podman-network-opnform_default.service"
    ];
    partOf = [
      "podman-compose-opnform-root.target"
    ];
    wantedBy = [
      "podman-compose-opnform-root.target"
    ];
  };

  # Networks
  systemd.services."podman-network-opnform_default" = {
    path = [ pkgs.podman ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStop = "podman network rm -f opnform_default";
    };
    script = ''
      podman network inspect opnform_default || podman network create opnform_default
    '';
    partOf = [ "podman-compose-opnform-root.target" ];
    wantedBy = [ "podman-compose-opnform-root.target" ];
  };

  # When started, this will automatically create all resources and start
  # the containers. When stopped, this will teardown all resources.
  systemd.targets."podman-compose-opnform-root" = {
    unitConfig = {
      Description = "Root target generated by compose2nix.";
    };
    wantedBy = [ "multi-user.target" ];
  };

  services.nginx.virtualHosts."forms.fsim-ev.de" = {
    forceSSL = true;
    enableACME = true;

    locations."/" = {
      proxyPass = "http://localhost:3001";
      recommendedProxySettings = true;
    };

  };
}
