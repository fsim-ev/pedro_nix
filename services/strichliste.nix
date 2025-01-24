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

      specificSounds = {
        "1" = {
          # Mio Mio Mate
          sounds = [
            ./strichliste/mate_01.wav
          ];
        };

        "3" = {
          # Wasser
          sounds = [
            ./strichliste/wasser_1.wav
          ];
        };

        "4" = {
          # Club Mate
          sounds = [
            ./strichliste/club_mate_1.wav
            ./strichliste/mate_01.wav
          ];
        };

        "6" = {
          # Saftschorle
          sounds = [
            ./strichliste/moneyboy_orangensaft.wav
          ];
        };

        "7"= {
          # Bier
          sounds = [
            ./strichliste/bier_1.wav
            ./strichliste/bier_2.wav
            ./strichliste/bier_3.wav
            ./strichliste/bier_4.wav
          ];
        };

        "9" = {
          # Bueno
          sounds = [
            ./strichliste/bueno_1.wav
          ];
        };

        "12" = {
          # Erdnüsse klein
          sounds = [
            ./strichliste/eier.wav
          ];
        };

        "14" = {
          # Belaste
          sounds = [
            ./strichliste/emotional-damage.wav
          ];
        };

        "19" = {
          # Maoam
          sounds = [
            ./strichliste/maoam_1.wav
          ];
        };

        "20" = {
          # Mentos
          sounds = [
            ./strichliste/eier.wav
          ];   
        };

        "23" = {
          # Spezi
          sounds = [
            ./strichliste/spezifische_spezi_fischer.wav
          ];
        };

        "24" = {
          # Kaffee
          sounds = [
            ./strichliste/coffee.wav
            ./strichliste/coffee_2.wav
            ./strichliste/coffee_3.wav
          ];         
        };

        "25" = {
          # Pizza
          sounds = [
            ./strichliste/pizza_1.wav
          ];
        };

        "26" = {
          # Snickers
          sounds = [
            ./strichliste/snickers_1.wav
          ];
        };

        "27" = {
          # Radler
          sounds = [
            ./strichliste/radler.wav
          ];
        };

        "28" = {
          # Mio Mio Banane
          sounds = [
            ./strichliste/minion_banana.wav
            ./strichliste/mio_mio_banana_2.wav
          ];
        };

        "30" = {
          # Duplo
          sounds = [
            ./strichliste/duplo_1.wav
            ./strichliste/duplo_2.wav
          ];
        };
      };
    };

    nginxSettings = {
      configure = true;
      domain = "strichliste.fsim-ev.de";
    };

    databaseUrl = "mysql://strichliste@localhost/strichliste";

    settings = {
      payment.boundary.lower = -5000;
      account.boundary.lower = -2000;

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
