{ config, lib, ... }:
{

  age.secrets = {
    zigbee2mqtt-secrets =
      let
        zb2mqttService = config.systemd.services.zigbee2mqtt.serviceConfig;
      in
      {
        file = ../secrets/zigbee2mqtt-secrets-yaml.age;
        path = "${config.services.zigbee2mqtt.dataDir}/secrets.yaml";
        owner = zb2mqttService.User;
        group = zb2mqttService.Group;
      };
  };

  services.mosquitto = {
    enable = true;
    listeners = [
      {
        address = "127.0.0.1";
        port = 1883;

        omitPasswordAuth = true;
        acl = [ "pattern readwrite #" ];
        settings.allow_anonymous = true;
      }
    ];
  };

  services.zigbee2mqtt = {
    enable = true;
    settings = {
      permit_join = true;
      serial.port = "/dev/ttyUSB0";
      frontend = {
        port = 8364;
        auth_token = "!secrets.yaml auth_token";
      };

      availability.enabled = true;
      homeassistant = lib.optionalAttrs config.services.home-assistant.enable {
        enable = true;
      };

      mqtt = {
        server = "mqtt://127.0.0.1:1883";
        base_topic = "zigbee2mqtt";
      };

    };
  };

  services.nginx.virtualHosts."zb2mqtt.room.fsim-ev.de" = {
    forceSSL = true;
    useACMEHost = "wildcard.room.fsim-ev.de";

    locations."/" = {
      proxyPass = "http://localhost:${toString config.services.zigbee2mqtt.settings.frontend.port}";
      proxyWebsockets = true;
      recommendedProxySettings = true;
    };
  };
}
