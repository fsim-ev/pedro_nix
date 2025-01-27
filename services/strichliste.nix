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
        "Wasser" = {
          sounds = [
            ./strichliste/wasser_1.wav
          ];
        };

        "Club Mate" = {
          sounds = [
            ./strichliste/club_mate_1.wav
          ] ++ mioMioMateSounds;
        };

        "Saft Apfel+Cranberry-Heidelbeere" = {
          sounds = saftSchorleSounds;
        };

        "Bier" = {
          sounds = [
            ./strichliste/bier_1.wav
            ./strichliste/bier_2.wav
            ./strichliste/bier_3.wav
            ./strichliste/bier_4.wav
            ./strichliste/bier_5.wav
          ];
        };

        "Bueno" = {
          sounds = [
            ./strichliste/bueno_1.wav
          ];
        };

        "Erdnüsse klein" = {
          sounds = [
            ./strichliste/eier.wav
          ];
        };

        "Belasto (Balisto) orange" = {
          sounds = belastoSounds;
        };

        "Belasto (Balisto) grün" = {
          sounds = belastoSounds;
        };

        "Maoam Bloxx" = {
          sounds = [
            ./strichliste/maoam_1.wav
          ];
        };

        "Mentos klein" = {
          sounds = [
            ./strichliste/eier.wav
          ];   
        };

        "Spezi" = {
          sounds = [
            ./strichliste/spezifische_spezi_fischer.wav
          ];
        };

        "Kaffee" = {
          sounds = [
            ./strichliste/coffee.wav
            ./strichliste/coffee_2.wav
            ./strichliste/coffee_3.wav
          ];         
        };

        "Pizza" = {
          sounds = [
            ./strichliste/pizza_1.wav
          ];
        };

        "Snickers classic" = {
          sounds = [
            ./strichliste/snickers_1.wav
          ];
        };

        "Radler" = {
          sounds = [
            ./strichliste/radler.wav
          ];
        };

        "Mio Mio Banane" = {
          sounds = [
            ./strichliste/minion_banana.wav
            ./strichliste/mio_mio_banana_2.wav
          ];
        };

        "Mio Mio Zero" = {
          sounds = mioMioMateSounds;
        };

        "Mio Mio Ginger" = {
          sounds = mioMioMateSounds;
        };

        "Mio Mio Mate" = {
          sounds = mioMioMateSounds;
        };

        "Mio Mio Cola" = {
          sounds = mioMioMateSounds;
        };

        "Saft Apfel+Johannisbeeren" = {
          sounds = saftSchorleSounds;
        };

        "Apfelschorle" = {
          sounds = saftSchorleSounds;
        };

        "Apfelschorle naturtrüb" = {
          sounds = saftSchorleSounds;
        };

        "Duplo classic" = {
          sounds = duploSounds;
        };

        "Duplo White" = {
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
