{ ... }:
{

  imports = [
    ./acme.nix
    ./homeassistant.nix
    ./nginx.nix
    ./borgbackup.nix
    ./zigbee2mqtt.nix
  ];
}
