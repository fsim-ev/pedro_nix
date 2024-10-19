{
  ...
}:{
  services.nginx = {
    enable = true;
    recommendedGzipSettings = true;
    recommendedOptimisation = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;
    clientMaxBodySize = "256m";
  };

  security.acme = {
    acceptTerms = true;
    defaults.email = "fachschaft_im@oth-regensburg.de";
  };
}
