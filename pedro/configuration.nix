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

  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    trusted-users = [ "@wheel" ];

    auto-optimise-store = true;
  };

  nix.gc = {
    automatic = false;
    persistent = true;

    options = "--delete-older-than +10";
    dates = "05:00:00"; 
  };
  boot.binfmt.emulatedSystems =
    lib.lists.filter (sys: pkgs.stdenv.hostPlatform.system != sys) [
      "x86_64-linux"
      "aarch64-linux"
  ];
  #temporary do not push to infra repo
  # virtualisation.oci-containers.containers = lib.listToAttrs(
  # lib.genList(i: {name = "reversi-client-${toString (i+1)}";
  # value={
  #    image = "reversi-client:latest";
  #    cmd = ["--server-url" " https://reversi.srwt.de"];
  #   autoStart = true;
  # } ;}) 24);
  # virtualisation.containers.registries.search = [
  #    "docker.io"
  #    "quay.io"
  #    "localhost"
  # ];


  networking.firewall.enable = true;
  system.stateVersion = "24.05"; # Did you read the comment?

  time.timeZone = "Europe/Berlin";

  # Select internationalization properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "de";
  };
}

