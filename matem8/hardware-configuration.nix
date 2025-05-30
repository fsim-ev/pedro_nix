# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, modulesPath, ... }:

{
  # imports =
  #   [ (modulesPath + "/installer/scan/not-detected.nix")
  #   ];

  boot.initrd.availableKernelModules = [ ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/44444444-4444-4444-8888-888888888888";
      fsType = "ext4";
    };

  swapDevices = [ ];

  networking.hostName = "matem8";

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.enu1u1u1.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlan0.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "aarch64-linux";

  # hardware.deviceTree.overlays = [
  #   { name = "precompiled"; dtboFile = ./vc4-kms-v3d.dtbo; }
  # ];
  #
  raspberry-pi-nix.board = "bcm2711";

  hardware.raspberry-pi.config.all = {
    options = {
      display_auto_detect = {
        enable = true;
        value = 1;
      };
    };
    
    dt-overlays = {
      vc4-kms-v3d = {
        enable = true;
        params = { };
      };
    };
  };
}
