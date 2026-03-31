{ lib, ... }:
let
  inherit (lib) mkMerge;
  create_redirect = source: target: {
    "/${source}".return = "301 ${target}";
  };
in
{
  security.acme.certs."l.fsim-ev.de".inheritDefaults = true;
  services.nginx.virtualHosts."l.fsim-ev.de" = {
    enableACME = true;
    forceSSL = true;
    locations = mkMerge [
      (create_redirect "bouldern" "https://chat.fsim-ev.de/#narrow/channel/9-Events/topic/Boulder-Monday/with/43194")
      (create_redirect "" "https://fsim-ev.de")

    ];

  };
}
