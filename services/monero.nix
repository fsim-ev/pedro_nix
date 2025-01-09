{
  ...
}:{
  services.monero = {
    enable = true;

    rpc.address = "0.0.0.0";

    extraConfig = ''
      confirm-external-bind=1
    '';
  };  
}
