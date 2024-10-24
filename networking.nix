{
  ...
}:{
  networking = {
    hostId = "e2c06a1b";
    hostName = "pedro";

    interfaces.eno8303 = {
      useDHCP = false;
      ipv4.addresses = [
        # tmp ip
        # {
        #   address = "194.95.108.46";
        #   prefixLength = 24;
        # }

        # "real" ip
        {
          address = "195.37.211.44";
          prefixLength = 27;
        }
      ];
    };

    defaultGateway = {
      address = "195.37.211.33";
      interface = "eno8303";
    };

    nameservers = [ 
      "194.95.106.120"
      "194.95.106.121"
    ];
  };

  networking.useDHCP = false;
}
