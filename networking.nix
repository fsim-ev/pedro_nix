{
  ...
}:{
  networking = {
    hostId = "e2c06a1b";
    hostName = "pedro";

    hosts = {
      "10.24.1.2" = [
        "fren.fsim"
        "monolith.fsim"
      ];
    };
    nat = {
      enable = true;
      externalInterface = "eno8303";
      # internal interfaces configured in other locations respectively
    };
   };

  boot.kernel.sysctl = {
    # Allow containers to access internet
    "net.ipv4.ip_forward" = 1;
  };

  systemd.network = {
    networks."10-wan" =  {
    matchConfig.Name = "eno8303";
    address = [
          "195.37.211.44/27"
    ];
  routes = [ {Gateway = "195.37.211.33";} ];
  dns = [ 
      "194.95.106.120"
      "194.95.106.121"
  ];

  linkConfig.RequiredForOnline = "routable";
  };

};

networking.nat.internalInterfaces = ["br0" ];
 systemd.network = {
   netdevs = {
     "20-br0" = {
       netdevConfig = {
         Name = "br0";
         Kind = "bridge";
       };
     };
   };
   networks = {
     "30-eno8303" = {
       matchConfig.Name = "eno8303";
       networkConfig.Bridge = "br0";
       linkConfig.RequiredForOnline = "enslaved";
     };
     "40-br0" = {
       matchConfig.Name = "br0";
       addresses = [ { Address = "10.1.0.1/24"; } ];
       bridgeConfig = {};
       linkConfig.RequiredForOnline = "carrier";
     };
     "11-vms" = {
        matchConfig.Name = "vm-*";
        networkConfig.Bridge = "br0";
     };
   };
 };
}
