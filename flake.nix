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

    treefmt-nix.url = "github:numtide/treefmt-nix";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    strichliste-rs = {
      url = "github:strichliste-rs/strichliste-rs";
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
        pedro = nixpkgs.lib.nixosSystem rec {
          system = "x86_64-linux";
          modules = [
            ./pedro/configuration.nix
            inputs.strichliste.nixosModules.strichliste
            inputs.microvm-nix.nixosModules.host
            inputs.strichliste-rs.nixosModules.${system}.default
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
        apollo = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            inputs.home-manager.nixosModules.home-manager
            ./apollo/configuration.nix
          ];
        };
      };
      deploy = {
        activationTimeout = 600;
        confirmationTimeout = 120;
        nodes = {
          monolith =
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
          apollo =
            let
              machine = self.nixosConfigurations.apollo;
            in
            {
              hostname = "apollo"; # this will be resolved at the backup server
              profiles.system = {
                user = "root";
                sshUser = "root";
                path = inputs.deploy-rs.lib.${machine.pkgs.system}.activate.nixos machine;
                sshOpts = [
                  "-J"
                  "10.24.1.2"
                ];
              };
            };
        };
      };
      formatter =
        let
          system = "x86_64-linux";
          pkgs = import nixpkgs { inherit system; };

          formattingConfig =
            { ... }:
            {
              projectRootFile = "flake.nix";
              programs.nixfmt.enable = true;
            };
          treeFmtEval = inputs.treefmt-nix.lib.evalModule pkgs formattingConfig;
        in
        {

          "${system}" = treeFmtEval.config.build.wrapper;
        };
    };
}
