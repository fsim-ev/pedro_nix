{
  config,
  ...
}:
{
  age.secrets = {
    wireguard-priv-key-proxy-ole.file = ../secrets/wireguard-priv-key-proxy-ole.age;
    wireguard-key-fsim-room-tunnel.file = ../secrets/wireguard-key-fsim-room-tunnel.age;
  };

  networking.wireguard = {
    enable = true;
    useNetworkd = false;
    interfaces = {
      "wg0" = {
        privateKeyFile = config.age.secrets.wireguard-key-fsim-room-tunnel.path;
        listenPort = 4422;
        ips = [ "10.24.1.1/32" ];
        peers = [
          {
            allowedIPs = [
              "10.24.1.2/32"
              "10.24.0.0/24"
            ];
            publicKey = "ElcCWQwmO1kyLYZOq30DkAwhy8F7Xh7A3jwJLTkUGHY=";
          }
          {
            allowedIPs = [ "10.24.1.101/32" ];
            publicKey = "Lw+fIYm7MQ9vZ21p3qKPsPe67occouBQb4VceQKjATQ=";
          }
        ];
      };

      "wg1" = {
        privateKeyFile = config.age.secrets.wireguard-priv-key-proxy-ole.path;

        ips = [ "10.100.0.6/32" ];
        peers = [
          {
            publicKey = "cLPAuu+Pu0nTBenl+ezZyjtVNqP3WYBzKM8BPYQ4Jh8=";
            endpoint = "ole.blue:53";
            persistentKeepalive = 25;
            allowedIPs = [ "10.100.0.0/24" ];
          }
        ];
      };
    };
  };

  networking.firewall.allowedUDPPorts = [ config.networking.wireguard.interfaces.wg0.listenPort ];

}
