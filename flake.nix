{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";

    unstable-nix = {
      url = "github:nixos/nixpkgs/nixos-unstable";
    };

    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, ...}@inputs: {
    nixosConfigurations.pedro = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./configuration.nix

        inputs.agenix.nixosModules.default
      ];

      specialArgs = let
        unstable = import (inputs.unstable-nix) { system = "x86_64-linux"; config.allowUnfree = true; };
      in { inherit  unstable inputs; };
    };
  };
}
