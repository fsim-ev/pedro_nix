{
  ...
}:
{
  # security.pki.certificateFiles = [
  #   ../certs/oth_ldap.pem
  #   ../certs/ca_1.pem
  #   ../certs/ca_2.pem
  # ];

  networking = {
    hostId = "e2c06a1b";
    hostName = "pedro";
    useDHCP = false;

    useNetworkd = true;

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

  networking.nat.internalInterfaces = [ "microvm-bridge" ];
  systemd.network =
    let
      microvm-name = "microvm-bridge";
    in
    {

      netdevs."10-microvm".netdevConfig = {
        Kind = "bridge";
        Name = microvm-name;
      };

      networks."10-wan" = {
        matchConfig.Name = "eno8303";
        address = [
          "195.37.211.44/27"
        ];
        routes = [ { Gateway = "195.37.211.33"; } ];
        dns = [
          "194.95.106.120"
          "194.95.106.121"
        ];

        linkConfig.RequiredForOnline = "routable";
      };

      networks = {
        "30-eno8303" = {
          matchConfig.Name = "eno8303";
          networkConfig.Bridge = microvm-name;
          linkConfig.RequiredForOnline = "enslaved";
        };

        "10-microvm" = {
          matchConfig.Name = microvm-name;
          addresses = [ { Address = "192.168.3.1/24"; } ];
        };

        "11-microvm" = {
          matchConfig.Name = "vm-*";
          networkConfig.Bridge = microvm-name;
        };
      };
    };
}
