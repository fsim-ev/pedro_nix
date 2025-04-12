{
  inputs,
  ...
}:{
  services.nginx.virtualHosts."beta.fsim-ev.de" = {
    forceSSL = true;
    enableACME = true;
    locations."/".root = inputs.website.packages.x86_64-linux.default;
  };

}
