{
  config,
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    inputs.opnform-nextcloud.nixosModules.default
  ];
  age.secrets.opnform-nextcloud-config = {
    file = ../secrets/opnform-nextcloud-config.age;
    owner = config.services.opnform-nc-proxy.user;
    group = config.services.opnform-nc-proxy.group;
  };
  services.nginx.virtualHosts = {
    "hivemind.fsim-ev.de" = {
      forceSSL = true;
      enableACME = true;
      globalRedirect = "forms.fsim-ev.de/forms/contact-form-teyzfb";
    };
    "opnform-nc-proxy.fsim-ev.de" = {
      forceSSL = true;
      enableACME = true;
      locations."/".proxyPass = "http://127.0.0.1:3000";
    };
  };

  services.opnform-nc-proxy = {
    enable = true;
    configFile = config.age.secrets.opnform-nextcloud-config.path;
  };
}
