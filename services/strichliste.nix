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

      specificSounds = let
        mioMioMateSounds = [
          ./strichliste/mate_01.wav
        ];

        saftSchorleSounds = [
          ./strichliste/moneyboy_orangensaft.wav
        ];

        duploSounds = [
          ./strichliste/duplo_1.wav
          ./strichliste/duplo_2.wav
        ];

        belastoSounds = [
          ./strichliste/emotional-damage.wav
        ];
      in {
        "3" = {
          # Wasser
          sounds = [
            ./strichliste/wasser_1.wav
          ];
        };

        "35" = {
          # Club Mate
          sounds = [
            ./strichliste/club_mate_1.wav
          ] ++ mioMioMateSounds;
        };

        "6" = {
          # Saftschorle
          sounds = saftSchorleSounds;
        };

        "52" = {
          # Bier
          sounds = [
            ./strichliste/bier_1.wav
            ./strichliste/bier_2.wav
            ./strichliste/bier_3.wav
            ./strichliste/bier_4.wav
            ./strichliste/bier_5.wav
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

        "61" = {
          # Belasto orange
          sounds = belastoSounds;
        };

        "62" = {
          # Belasto grün
          sounds = belastoSounds;
        };

        "40" = {
          # Maoam
          sounds = [
            ./strichliste/maoam_1.wav
          ];
        };

        "41" = {
          # Mentos
          sounds = [
            ./strichliste/eier.wav
          ];   
        };

        "34" = {
          # Spezi
          sounds = [
            ./strichliste/spezifische_spezi_fischer.wav
          ];
        };

        "64" = {
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

        "54" = {
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

        "36" = {
          # Mio Mio Zero
          sounds = mioMioMateSounds;
        };

        "37" = {
          # Mio Mio Ginger
          sounds = mioMioMateSounds;
        };

        "38" = {
          # Mio Mio Mate
          sounds = mioMioMateSounds;
        };

        "39" = {
          # Mio Mio Cola
          sounds = mioMioMateSounds;
        };

        "42" = {
          # Saftschorle Cran Berry
          sounds = saftSchorleSounds;
        };

        "49" = {
          # Apfelschorle
          sounds = saftSchorleSounds;
        };

        "50" = {
          # Apfelschrole Naturtrüb
          sounds = saftSchorleSounds;
        };

        "51" = {
          # Duplo
          sounds = duploSounds;
        };

        "53" = {
          # Duplo
          sounds = duploSounds;
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
