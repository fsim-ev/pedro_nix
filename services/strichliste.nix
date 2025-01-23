{
  config,
  ...
}:{
  services.strichliste = {
    enable = true;

    customSounds = {
      enable = true;

      depositSounds = [
        ./strichliste/spongebob_moneten.wav
      ];

      failedSounds = [
        ./strichliste/windows_error.wav
      ];

      withdrawSounds = [
        ./strichliste/wobble.wav
      ];

      baselineSounds = [
        ./strichliste/ka-ching.wav
        ./strichliste/mario-coin.wav
        ./strichliste/futterlucke.wav
      ];

      specificSounds = [
        {
          # Mio Mio Mate
          id = 1;
          sounds = [
            ./strichliste/mate_01.wav
          ];
        }
        {
          # Wasser
          id = 3;
          sounds = [
            ./strichliste/wasser_1.wav 
          ];
        }
        {
          # Club mate
          id = 4;
          sounds = [
            ./strichliste/club_mate_1.wav
            ./strichliste/mate_01.wav
          ];
        }
        {
          # Saftschorle
          id = 6;
          sounds = [
            ./strichliste/moneyboy_orangensaft.wav
          ];
        }
        {
          # Bueno
          id = 9;
          sounds = [
            ./strichliste/bueno_1.wav
          ];
        }
        {
          # Erdnüsse klein
          id = 12;
          sounds = [
            ./strichliste/eier.wav
          ];
        }
        {
          # Belaste
          id = 14;
          sounds = [
            ./strichliste/emotional-damage.wav
          ];
        }
        {
          # Snickers
          id = 16;
          sounds = [
            ./strichliste/snickers_1.wav
          ];
        }
        {
          # Maoam
          id = 19;
          sounds = [
            ./strichliste/maoam_1.wav
          ];
        }
        {
          # Mentos
          id = 20;
          sounds = [
            ./strichliste/eier.wav
          ];   
        }
        {
          # Spezi
          id = 23;
          sounds = [
            ./strichliste/spezifische_spezi_fischer.wav
          ];
        }
        {
          # Kaffee
          id = 24;
          sounds = [
            ./strichliste/coffee.wav
            ./strichliste/coffee_2.wav
            ./strichliste/coffee_3.wav
          ];         
        }
        {
          # Pizza
          id = 25;
          sounds = [
            ./strichliste/pizza_1.wav
          ];
        }
        {
          # Radler
          id = 27;
          sounds = [
            ./strichliste/radler.wav
          ];
        }
        {
          # Mio Mio Banane
          id = 28;
          sounds = [
            ./strichliste/minion_banana.wav
            ./strichliste/mio_mio_banana_2.wav
          ];
        }
        {
          # Duplo
          id = 30;
          sounds = [
            ./strichliste/duplo_1.wav
            ./strichliste/duplo_2.wav
          ];
        }
      ];
    };

    nginxSettings = {
      configure = true;
      domain = "strichliste.fsim-ev.de";
    };

    databaseUrl = "mysql://strichliste@localhost/strichliste";

    settings = {
      payment.boundary.upper = 200000;
      account.boundary.upper = 200000;

      article.autoOpen = true;
    };
  };

  services.nginx.virtualHosts.${config.services.strichliste.nginxSettings.domain} = {
    forceSSL = true;
    enableACME = true;

    locations."/".extraConfig = ''
      allow 172.20.36.242/32;
      deny all;

      error_page 403 @custom403;
    '';

    locations."/api/metrics" = {
      extraConfig = ''
        deny all;
      '';
    };


    locations = {
      "@custom403" = {
        extraConfig = ''
          default_type text/html;
          return 200 '<html>
          <head><title>403 Forbidden</title></head>
          <body>
            <h1>Du musst leider in die Fachschaft kommen, um abzurechnen.</h1>
          </body>
          </html>';
        '';
      };
    };
  };

  services.mysql = {

    ensureUsers = [
      {
        name = "strichliste";
        ensurePermissions = {
          "strichliste.*" = "ALL PRIVILEGES";
        };
      }
      {
        name = "grafana";
        ensurePermissions = {
          "strichliste.*" = "SELECT";
        };
      }
    ];

    ensureDatabases = [
      "strichliste"
    ];
  };
}
