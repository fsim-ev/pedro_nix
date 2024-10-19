{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-24.05";

    unstable-nix = {
      url = "github:nixos/nixpkgs?ref=nixos-unstable";
    };
  };

  outputs = { self, nixpkgs, unstable-nix }@inputs: {
    nixosConfigurations.pedro = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./configuration.nix
      ];

      specialArgs = let
        unstable = import (unstable-nix) { system = "x86_64-linux"; config.allowUnfree = true; };
      in { inherit  unstable; };
    };
  };
}
