# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "mpt3sas" "ahci" "usbhid" "usb_storage" "sd_mod" "sr_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    { device = "storage/root";
      fsType = "zfs";
    };

  fileSystems."/home" =
    { device = "storage/home";
      fsType = "zfs";
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/1853-85BE";
      fsType = "vfat";
      options = [ "fmask=0022" "dmask=0022" ];
    };

  fileSystems."/var/lib/zulip" = {
    device = "storage/services/zulip";
    fsType = "zfs";
  };

  fileSystems."/var/lib/postgresql" = {
    device = "storage/services/postgresql";
    fsType = "zfs";
  };

  fileSystems."/var/lib/hedgedoc" = {
    device = "storage/services/hedgedoc";
    fsType = "zfs";
  };

  fileSystems."/var/lib/passbolt" = {
    device = "storage/services/passbolt";
    fsType = "zfs";
  };

  fileSystems."/var/lib/nextcloud" = {
    device = "storage/services/nextcloud";
    fsType = "zfs";
  };

  fileSystems."/var/lib/engelsystem" = {
    device = "storage/services/engelsystem";
    fsType = "zfs";
  };

  fileSystems."/var/lib/www/examia.de" = {
    device = "storage/services/examia";
    fsType = "zfs";
  };

  fileSystems."/var/lib/strichliste" = {
    device = "storage/services/strichliste";
    fsType = "zfs";
  };

  services.zfs = {
    autoScrub.enable = true;
    trim.enable = true;
  };

  swapDevices = [ ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  nixpkgs.config.allowUnfree = true;
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia-container-toolkit.enable = true;
  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = false;
    powerManagement.finegrained = false;
    open = false;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
    # nvidiaPersistenced = true;
  };

   # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
}
