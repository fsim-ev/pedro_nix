{
  ...
}:{
  networking = {
    hostId = "e2c06a1b";
    hostName = "pedro";

    interfaces.eno8303 = {
      ipv4.addresses = [
        {
          address = "194.95.108.46";
          prefixLength = 24;
        }
      ];
    };

    defaultGateway = {
      address = "194.95.108.250";
      interface = "eno8303";
    };

    nameservers = [ 
      "194.95.106.120"
      "194.95.106.121"
    ];
  };

  networking.useDHCP = false;
}
