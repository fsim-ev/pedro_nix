{
  description = "A very basic flake";

  inputs = {
    # nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    stable-nix = {
      url = "github:nixos/nixpkgs/nixos-25.05";
    };

    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    strichliste = {
      url = "github:DestinyofYeet/nix-strichliste";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    website = {
      url = "github:fsim-ev/website";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    docker-tag-zulip.url = "github:fsim-ev/docker_tag_flake/zulip/docker-zulip";
    docker-tag-passbolt.url = "github:fsim-ev/docker_tag_flake/passbolt/passbolt";
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
