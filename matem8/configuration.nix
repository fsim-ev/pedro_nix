# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the extlinux boot loader. (NixOS wants to enable GRUB by default)
  boot.loader.grub.enable = false;
  # Enables the generation of /boot/extlinux/extlinux.conf
  boot.loader.generic-extlinux-compatible.enable = true;

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  networking.hostName = "nixos";

  services.xserver.enable = true;

  programs.firefox.enable = true;

  services.getty.autologinUser = "root";

  users.users.root = {
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEHeF66q9/UKixJjXGjYXTlwrYcSfMVaYD+W/3pJ+4DP ole@wattson"
    ];
  };
  

  services.xserver.xkb.layout = "de";
  services.libinput.enable = true;

  environment.systemPackages = with pkgs; [
    helix vim
    btop
  ];

  documentation.enable = false;

  services.openssh = {
    enable = true;
    openFirewall = true;
    settings = {
      PasswordAuthentication = false;
    };
  };

  system.stateVersion = "25.05"; # Did you read the comment?

}

