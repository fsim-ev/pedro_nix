{
config,
  ...
}:{
  services.monero = {
    enable = true;

    rpc.address = "0.0.0.0";

    extraConfig = ''
      confirm-external-bind=1
    '';
  };  
  networking.firewall.allowedTCPPorts = [ config.services.monero.rpc.port 18080 18081 18082];
}
