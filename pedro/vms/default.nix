{
  pkgs,
  lib,
  inputs,
  ...
}:let
  mkVM = name: settings: {
    "${name}" = {
      pkgs = settings.pkgs or pkgs;
      config = lib.mkMerge [
        {
          microvm = {
            interfaces = [{
              type = "tap";
              id = "vm-${name}";
              mac = settings.mac;
            }];
          };

          networking.useNetworkd = false;
          systemd.network = {
            enable = true;
            networks."20-lan" = {
              matchConfig.Type = "ether";
              networkConfig = {
                Address = [ "${settings.ip}/24" ];
                Gateway = "192.168.3.1";
                DNS = [ "8.8.8.8" "9.9.9.9" ];
                IPv6AcceptRA = true;
                DHCP = "no";
              };
            };
          };
          networking.useDHCP = lib.mkForce false;
        }

        settings.config
      ];
    };
  };
in {
    microvm = {
      host.enable = true;
      vms = lib.mkMerge [
        (mkVM "gh-runner" {
          ip = "192.168.3.10";
          mac = "02:00:00:00:00:01";
          config = {
            imports = [
              inputs.agenix.nixosModules.default

              ./github-runner
            ];
          };
          inherit pkgs;
        })
      ];
    };
  }
