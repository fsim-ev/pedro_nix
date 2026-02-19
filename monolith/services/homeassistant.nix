{ config, stable, ... }:{
  services.home-assistant = {
    enable = true;

    extraComponents = [
      "history"
      "mqtt"

      # Components required to complete the onboarding
      "analytics"
      "google_translate"
      "met"
      "radio_browser"
      "shopping_list"
      # Recommended for fast zlib compression
      # https://www.home-assistant.io/integrations/isal
      "isal"
    ];

    config = {
      http = {
        server_host = "127.0.0.1";
        server_port = 8123;

        use_x_forwarded_for = true;
        trusted_proxies = ["127.0.0.1"];
      };

      homeassistant = {
        time_zone = "Europe/Berlin";
        unit_system = "metric";
        temperature_unit = "C";
      };

      automation = "!include automations.yaml";

      assist_pipeline = { };
      config = { };
      dhcp = { };
      energy = { };
      history = { };
      homeassistant_alerts = { };
      logbook = { };
      mobile_app = { };
      my = { };
      ssdp = { };
      stream = { };
      sun = { };
      usb = { };
      webhook = { };
      zeroconf = { };
    };
  };


  services.nginx.virtualHosts."room.fsim-ev.de" = {
    forceSSL = true;
    useACMEHost = "room.fsim-ev.de";

    locations."/" = let
        haConfig = config.services.home-assistant.config.http;
      in {
        proxyPass = "http://${haConfig.server_host}:${toString haConfig.server_port}";

        proxyWebsockets = true;
        recommendedProxySettings = true;
    };
  };
}
