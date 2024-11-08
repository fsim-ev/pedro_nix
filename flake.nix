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
  };

  outputs = { self, nixpkgs, ...}@inputs: {
    nixosConfigurations.pedro = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./configuration.nix

        inputs.agenix.nixosModules.default
      ];


      specialArgs = let
        stable = import (inputs.stable-nix) { system = "x86_64-linux"; config.allowUnfree = true; };
      in { inherit  stable inputs; };
    };
  };
}
