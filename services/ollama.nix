{
  config,
  ...
}:{

  nixpkgs.config.allowUnfree = true;
  
  services.ollama = {
    enable = true;
    acceleration = "cuda";
  };

  services.open-webui = {
    host = "0.0.0.0";
    enable = false;
    port = 16753;
  };

  # pedro nur vom internen netz erreichbar => kein ACME certificate
  # services.nginx.virtualHosts = {
  #   "ai.pedro.fsim-ev.de" = {
  #     locations."/".proxyPass = "http://localhost:${builtins.toString config.services.open-webui.port}";
  #     forceSSL = true;
  #     enableACME = true;
  #   };
  # };
}
