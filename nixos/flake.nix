{
  description = "A very basic flake";

  inputs = {
    # nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
    nixpkgs.url = "github:nixos/nixpkgs";

    stable-nix = {
      url = "github:nixos/nixpkgs/nixos-25.05";
    };

    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    strichliste = {
      url = "github:haennes/nix-strichliste";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    website = {
      url = "github:fsim-ev/website";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    docker-tag-zulip.url = "github:fsim-ev/docker_tag_flake/zulip/docker-zulip";
    docker-tag-passbolt.url = "github:fsim-ev/docker_tag_flake/passbolt/passbolt";
    deploy-rs = {
      url = "github:serokell/deploy-rs";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    microvm-nix = {
      url = "github:astro/microvm.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

  };

  outputs =
    { self, nixpkgs, ... }@inputs:
    let
      stable = import (inputs.stable-nix) {
        system = "x86_64-linux";
        config.allowUnfree = true;
      };
      specialArgs = { inherit stable inputs; };
      commonModules = [ inputs.agenix.nixosModules.default ];
    in
    {
      nixosConfigurations = {
        pedro = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./pedro/configuration.nix
            inputs.strichliste.nixosModules.strichliste
            inputs.microvm-nix.nixosModules.host
          ]
          ++ commonModules;
          inherit specialArgs;
        };
        monolith = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./monolith/configuration.nix
            inputs.agenix.nixosModules.default
          ]
          ++ commonModules;
          inherit specialArgs;
        };
      };
      deploy = {
        activationTimeout = 600;
        confirmationTimeout = 120;
        nodes.monolith =
          let
            machine = self.nixosConfigurations.monolith;
          in
          {
            hostname = "10.24.1.2";
            profiles.system = {
              user = "root";
              sshUser = "root";
              path = inputs.deploy-rs.lib.${machine.pkgs.system}.activate.nixos machine;
            };
          };
      };
    };
}
