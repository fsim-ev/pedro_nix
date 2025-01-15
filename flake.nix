{
  description = "A very basic flake";

  inputs = {
    # nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    stable-nix = {
      url = "github:nixos/nixpkgs/nixos-24.05";
    };

    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    strichliste = {
      url = "github:DestinyofYeet/nix-strichliste/docker";
      inputs.nixpkgs.follows = "nixpkgs";
      # url = "path:///home/ole/github/strichliste.nix";
    };

    deploy-rs = {
      url = "github:serokell/deploy-rs";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    rpi-nix = {
      url = "github:nix-community/raspberry-pi-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, ...}@inputs: {
    deploy.nodes = {
      matem8 = {
        hostname = "10.24.0.139";
        profiles.system = {
          sshUser = "root";
          # user = "root";
          # interactiveSudo = true;
          path = inputs.deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.matem8;
        };
      };

    nixosConfigurations.matem8 = nixpkgs.lib.nixosSystem {
      system = "aarch64-linux";
      modules = [
        ./matem8

        inputs.rpi-nix.nixoModules.raspberry-pi
      ];
    };

    nixosConfigurations.pedro = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./configuration.nix

        inputs.agenix.nixosModules.default
        # inputs.prost.nixosModules.default
        inputs.strichliste.nixosModules.strichliste
      ];
    };


      specialArgs = let
        stable = import (inputs.stable-nix) { system = "x86_64-linux"; config.allowUnfree = true; };
      in { inherit  stable inputs; };
    };
  };
}
