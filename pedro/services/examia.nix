{
  config,
  pkgs,
  ...
}:{
  services.phpfpm = {
    phpOptions = ''
      date.timezone = "Europe/Berlin"
    '';
    pools = {
      # Generic PHP pool
      # Used by:
      # - Examia
      websrv = {
        user = "nginx";
        group = "nginx";
        settings = {
          "pm" = "ondemand";
          "pm.max_children" = 10;
          "pm.max_requests" = 500;
          # dump hacks
          "listen.mode" = "0600";
          "listen.owner" = config.services.nginx.user;
          "listen.group" = config.services.nginx.group;
        };
      };
    };
  };

  services.mysql = {
    enable = true;
    package = pkgs.mariadb;
    ensureDatabases = [ "examia_phpbb" ];
    ensureUsers = [
      {
        name = "examia_phpbb";
        ensurePermissions."examia_phpbb.*" = "ALL PRIVILEGES";
        # Don't forget to set password for 'examia_phpbb@localhost'
      }
    ];
  };

  services.anubis.instances.examia = {
    enable = true;

    settings = {
      TARGET = "unix:///run/nginx/nginx-examia.sock";
      BIND = ":8786";
    };
  };


  services.nginx.virtualHosts = {
    "examia.de-frontend" = {
      serverName = "examia.de";
      serverAliases = ["www.examia.de"];

      forceSSL = true;
      enableACME = true;

      locations."/".proxyPass = "http://localhost${config.services.anubis.instances.examia.settings.BIND}/";
    };

    "examia.de-backend" = {
      listen = [
        {
          addr = "unix:/run/nginx/nginx-examia.sock";
        }
      ];

      serverName = "examia.de";
      serverAliases = ["www.examia.de"];

      root = "/var/lib/www/examia.de";
      locations."/".index = "index.php";
      extraConfig = ''
        index index.php index.html /index.php$request_uri;
        # Disallow senible phpbb files
        location ~ /(config\.php|common\.php|cache|files|images/avatars/upload|includes|store) {
          deny all;
          return 403;
        }

        location ~ /\.git {
          deny all;
        }

        # Disallow accessing .htaccess files
        location ~/\.ht {
          deny all;
        }

        location ~* \.(gif|jpe?g|png|css)$ {
          expires 30d;
        }

        location ~ \.php$ {
          include ${config.services.nginx.package}/conf/fastcgi.conf;
          try_files $uri =404;
          fastcgi_pass unix:/run/phpfpm/websrv.sock;
          fastcgi_split_path_info ^(.+\.php)(/.*)$;
          fastcgi_param PATH_INFO $fastcgi_path_info;
          fastcgi_index index.php;
          fastcgi_param PHP_VALUE "
            upload_max_filesize = 1G
            max_execution_time = 60
            max_input_time = 120
            post_max_size = 1G
          ";
        }

        location /app.php {
          try_files $uri $uri/ /app.php?$query_string;
        }

        location /install/app.php {
          try_files $uri $uri/ /install/app.php?$query_string;
        }
      '';   
    };
  };
}
