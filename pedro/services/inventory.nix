{
  config,
  pkgs,
  ...
}:
{
  services.homebox = {
    enable = true;
    # remove when merged: https://github.com/NixOS/nixpkgs/pull/421105/
    package = pkgs.callPackage ./homebox/homebox.nix {};
    database.createLocally = true;

    settings = {
      HBOX_WEB_HOST = "127.0.0.1";
      HBOX_WEB_PORT = "7745";
      # HBOX_OPTIONS_ALLOW_REGISTRATION = "true";
      HBOX_LABEL_MAKER_ADDITIONAL_INFORMATION = "Fachschaft IM";
    };
  };

  services.nginx.virtualHosts."inv.fsim-ev.de" = let
    cfg = config.services.homebox.settings;
  in {
    enableACME = true;
    forceSSL = true;

    locations."/" = {
      proxyPass = "http://${cfg.HBOX_WEB_HOST}:${cfg.HBOX_WEB_PORT}";
      proxyWebsockets = true;
    };
  };
}
