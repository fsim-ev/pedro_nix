# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./programs.nix
      ./users.nix
      ./networking.nix

      ./services
    ];

  console.keyMap = "de";

  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    trusted-users = [ "@wheel" ];

    auto-optimise-store = true;
  };

  nix.gc = {
    automatic = true;
    persistent = true;

    options = "--delete-older-than +10";
    dates = "05:00:00"; 
  };

  networking.firewall.enable = false;
  system.stateVersion = "24.05"; # Did you read the comment?
}

