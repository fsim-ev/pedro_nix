{
  config,
  ...
}:let
  # on host: /var/lib/microvms/gh-runner/persistent
  persistent_dir = "/persistent";
in {
    imports = [
      ./services
      ./packages.nix
    ];

    nix.settings = {
      experimental-features = [ "nix-command" "flakes" ];
    };

    system.stateVersion = "25.05";

    microvm = {
      vcpu = 8;
      mem = 8192;

      shares = [        
        {
          proto = "virtiofs";
          tag = "persistent";
          source = "persistent";
          mountPoint = persistent_dir;
        }
      ];

      volumes = [
        {
          image = "nix-store-overlay.img";
          mountPoint = config.microvm.writableStoreOverlay;
          size = 16384;
        }
        {
          image = "root.img";
          mountPoint = "/";
          size = 8192;
        }
      ];

      writableStoreOverlay = "/nix/.rw-store";
    };

    fileSystems."${persistent_dir}".neededForBoot = true;

    services.openssh = {
    hostKeys = [
      {
        path = "${persistent_dir}/hostkey";
        type = "ed25519";
      }
      {
        path = "${persistent_dir}/hostkey_rsa";
        type = "rsa";
        bits = 4096;
      }
    ];
    };
    age.identityPaths = [ "${persistent_dir}/hostkey" ];
  }
