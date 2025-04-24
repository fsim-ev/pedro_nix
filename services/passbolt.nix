{
  ...
}:let
  domain = "pass.fsim-ev.de";
  port = "8003";
  image_tag = "5.0.0-1-ce";
in {
  virtualisation.oci-containers.containers = {
    passbolt = {
      image = "passbolt/passbolt:${image_tag}";
      dependsOn = [ "passbolt-db" ];

      volumes = let 
        host-storage = "/var/lib/passbolt/passbolt";
      in [
        "${host-storage}/gpg:/etc/passbolt/gpg"
        "${host-storage}/jwt:/etc/passbolt/jwt"
      ];

      environment = {
        DATASOURCES_DEFAULT_PASSWORD = "passbolt";
        DATASOURCES_DEFAULT_HOST = "127.0.0.1";
        DATASOURCES_DEFAULT_USERNAME = "passbolt";
        DATASOURCES_DEFAULT_DATABASE = "passbolt";
        APP_FULL_BASE_URL = "https://${domain}";

        EMAIL_TRANSPORT_DEFAULT_HOST = "smtp.hs-regensburg.de";
        EMAIL_TRANSPORT_DEFAULT_PORT = "25";
        EMAIL_TRANSPORT_DEFAULT_TLS = "false";
        EMAIL_DEFAULT_FROM = "fachschaft_im@oth-regensburg.de";
        EMAIL_TRANSPORT_DEFAULT_USERNAME = "fachschaft_im@oth-regensburg.de";

      };

      extraOptions = [
        "--network=container:passbolt-db"
      ];
    };

    passbolt-db = {
      image = "mariadb";

      ports = [
        "${port}:80"
      ];

      volumes = [
        "/var/lib/passbolt/db:/var/lib/mysql"
      ];

      environment = {
        MARIADB_USER = "passbolt";
        MARIADB_PASSWORD = "passbolt";
        MARIADB_DATABASE = "passbolt";
        MARIADB_ROOT_PASSWORD = "root";
      };
    };
  };

  services.nginx.virtualHosts.${domain} = {
    forceSSL = true;
    enableACME = true;

    locations."/".proxyPass = "http://localhost:${port}";
  };
}
