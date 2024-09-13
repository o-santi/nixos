# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, inputs, modulesPath,  ... }: {
  imports = [
    inputs.mixrank.nixosModules.dev-machine
    inputs.nixos-hardware.nixosModules.framework-13-7040-amd
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  santi-modules = {
    desktop-environment.enable = true;
    services.ddns.enable = true;
  };
  # Bootloader.
  boot = {
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
    initrd = {
      luks.devices."luks-fc474bfb-2d0a-4a8a-99db-a55e15d8a836".device = "/dev/disk/by-uuid/fc474bfb-2d0a-4a8a-99db-a55e15d8a836";
      availableKernelModules = [
        "nvme"
        "xhci_pci"
        "thunderbolt"
        "usb_storage"
        "sd_mod"
      ];
    };
    kernelPackages = pkgs.linuxPackages_latest;
    kernelModules = [ "kvm-amd" ];
    kernelParams = lib.optionals (lib.versionOlder config.boot.kernelPackages.kernel.version "6.8") ["rtc_cmos.use_acpi_alarm=1"] ;
  };

  networking = {
    hostName = "larissa"; 
    networkmanager.enable = true;
    useDHCP = lib.mkDefault true;
  };
  # Custom services for laptop
  services = {
    power-profiles-daemon.enable = lib.mkDefault true;
    touchegg.enable = true;
    fwupd.enable = true;
    libinput = {
      enable = true;
      touchpad = {
        tapping = true;
        scrollMethod = "twofinger";
        clickMethod = "clickfinger";
        tappingButtonMap = "lrm";
      };
    };
  };
  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/bd4da861-db3f-4efd-82e1-ca925f8ef873";
      fsType = "ext4";
    };
    "/boot" = {
      device = "/dev/disk/by-uuid/D40E-FE35";
      fsType = "vfat";
      options = [ "fmask=0022" "dmask=0022" ];
    };
  };
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  system.stateVersion = "23.11"; 
}
