{ config, ... }:
{

  age.secrets = {
    hetzner-api-token.file = ../secrets/hetzner-dns-api-token.age;
  };

  security.acme = {
    acceptTerms = true;
    defaults = {
      email = "fachschaft_im@oth-regensburg.de";

      dnsProvider = "hetzner";
      group = "nginx";
      environmentFile = config.age.secrets.hetzner-api-token.path;
    };

    certs = {
      "wildcard.room.fsim-ev.de" = {
        domain = "*.room.fsim-ev.de";
      };
    };

    certs = {
      "room.fsim-ev.de" = {
        domain = "room.fsim-ev.de";
      };
    };
  };
}
