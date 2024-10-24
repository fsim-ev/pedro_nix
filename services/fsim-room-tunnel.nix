{
  ...
}:{
  networking.wireguard = {
    enable = true;
    interfaces."wg0" = {
      privateKeyFile = "/etc/nixos/secrets/secrets/wireguard-tunnel.key";
      listenPort = 4422;
      ips = [ "10.24.1.1/32" ];
      peers = [
        {
          allowedIPs = [ "10.24.1.2/32" "10.24.0.0/24" ];
          publicKey = "ElcCWQwmO1kyLYZOq30DkAwhy8F7Xh7A3jwJLTkUGHY=";
        }
        {
          allowedIPs = [ "10.24.1.101/32" ];
          publicKey = "Lw+fIYm7MQ9vZ21p3qKPsPe67occouBQb4VceQKjATQ=";
        }
      ];
    };
  };

}
