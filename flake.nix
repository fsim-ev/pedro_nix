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
      url = "github:DestinyofYeet/nix-strichliste/custom-frontend";
      inputs.nixpkgs.follows = "nixpkgs";
      # url = "path:///home/ole/github/strichliste.nix";
    };

  };

  outputs = { self, nixpkgs, ...}@inputs: {
    nixosConfigurations.pedro = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./configuration.nix

        inputs.agenix.nixosModules.default
        # inputs.prost.nixosModules.default
        inputs.strichliste.nixosModules.strichliste
      ];


      specialArgs = let
        stable = import (inputs.stable-nix) { system = "x86_64-linux"; config.allowUnfree = true; };
      in { inherit  stable inputs; };
    };
  };
}
