{
  config,
  lib,
  ...
}:
{
  services.strichliste-rs = {
    enable = true;
    address = "127.0.0.1";
    port = 8936;
    settings = {
      accounts = {
        upper_limit = 0;
        lower_limit = 0;
      };

      sounds = {
        generic = [
          ./strichliste/ka-ching.wav
          ./strichliste/mario-coin.wav
          ./strichliste/futterlucke.wav
        ];

        failed = [
          ./strichliste/windows_error.wav
        ];

        articles =
          let
            mioMioMateSounds = [
              ./strichliste/mate_01.wav
            ];

            saftSchorleSounds = [
              ./strichliste/moneyboy_orangensaft.wav
            ];

            belastoSounds = [
              ./strichliste/emotional-damage.wav
            ];

            duploSounds = [
              ./strichliste/duplo_1.wav
              ./strichliste/duplo_2.wav
            ];
            erdnussSounds = [
              ./strichliste/deeznuts.mp3
              ./strichliste/eier.wav
            ];

            punschSounds = [
              ./strichliste/christmas_sound.wav
              ./strichliste/christmas_sound2.wav
            ];

          in
          {
            "Wasser" = [
              ./strichliste/wasser_1.wav
            ];

            "Club Mate" = [
              ./strichliste/club_mate_1.wav
            ]
            ++ mioMioMateSounds;

            "Saft Apfel+Cranberry-Heidelbeere" = saftSchorleSounds;

            "Bueno" = [
              ./strichliste/bueno_1.wav
            ];

            "Belasto (Balisto) orange" = belastoSounds;

            "Belasto (Balisto) grün" = belastoSounds;

            "Maoam Bloxx" = [
              ./strichliste/maoam_1.wav
            ];

            "Mentos klein" = [
              ./strichliste/eier.wav
            ];

            "Bier" = [
              ./strichliste/bier_1.wav
              ./strichliste/bier_2.wav
              ./strichliste/bier_3.wav
              ./strichliste/bier_4.wav
              ./strichliste/bier_5.wav
            ];

            "Spezi" = [
              ./strichliste/spezifische_spezi_fischer.wav
            ];

            "Kaffee" = [
              ./strichliste/coffee.wav
              ./strichliste/coffee_2.wav
              ./strichliste/coffee_3.wav
            ];

            "Pizza" = [
              ./strichliste/pizza_1.wav
            ];

            "Snickers classic" = [
              ./strichliste/snickers_1.wav
            ];

            "Radler" = [
              ./strichliste/radler.wav
            ];

            "Mio Mio Banane" = [
              ./strichliste/minion_banana.wav
              ./strichliste/mio_mio_banana_2.wav
            ];

            "Mio Mio Zero" = mioMioMateSounds;

            "Mio Mio Ginger" = mioMioMateSounds;

            "Mio Mio Mate" = mioMioMateSounds;

            "Mio Mio Cola" = mioMioMateSounds;

            "Saft Apfel+Johannisbeeren" = saftSchorleSounds;

            "Apfelschorle" = saftSchorleSounds;

            "Apfelschorle naturtrüb" = saftSchorleSounds;

            "Duplo classic" = duploSounds;

            "Duplo White" = duploSounds;

            "Erdnüsse groß" = erdnussSounds;
            "Erdnüsse klein" = erdnussSounds;

            "Glühwein" = punschSounds;
            "Kinderpunsch" = punschSounds;
          };
      };
    };
  };

  services.nginx.virtualHosts."strichliste.fsim-ev.de" =
    let
      cfg = config.services.strichliste-rs;
    in
    {
      enableACME = true;
      forceSSL = true;

      locations."/" = {
        proxyPass = "http://${cfg.address}:${toString cfg.port}";

        extraConfig = ''
          allow 127.0.0.1;
          allow 195.37.211.44;
          allow 172.20.36.242/32;
          deny all;

          error_page 403 @custom403;
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

  systemd.services."strichliste-rs-exporter" = {
    script = ''
      cp /var/lib/private/strichliste-rs/database.db /var/lib/grafana/
      chown grafana:grafana /var/lib/grafana/database.db
    '';
  };

  systemd.timers."strichliste-rs-exporter" = {
    wantedBy = [ "multi-user.target" ];
    timerConfig.OnCalendar = "minutely";
  };
}
