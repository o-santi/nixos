# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, modulesPath, ... }: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];
  santi-modules.desktop-environment.enable = true;
  santi-modules.gnome.enable = lib.mkForce false;
  santi-modules.cosmic.enable = lib.mkForce true;

  # Bootloader.
  boot = {
    loader = {
      timeout = 0;
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    initrd = {
      availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usbhid" ];
    };
    binfmt.emulatedSystems = [ "aarch64-linux" ];
    kernelModules = [ "kvm-amd" ];
    kernelPackages = pkgs.linuxPackages_latest;
    extraModulePackages = [ ];
  };
 
  networking = {
    hostName = "kunagisa"; # Define your hostname.
    networkmanager.enable = true;
    firewall.enable = false;
    useDHCP = lib.mkDefault true;
  };

  virtualisation.docker.enable = true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  
  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/96c114a2-ffd7-476d-80fa-51e670c27e4b";
      fsType = "ext4";
    };
    "/boot" = {
      device = "/dev/disk/by-uuid/AA22-4A81";
      fsType = "vfat";
    };
  };

  programs.nix-ld.enable = true;

  swapDevices = [
    { device = "/dev/disk/by-uuid/1a204e5c-05cb-4e7f-b859-927fb024fb12"; }
  ];
  environment.variables.AMD_VULKAN_ICD = "RADV";
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  hardware.amdgpu.initrd.enable = true;
  services.lact.enable = true;
  system.stateVersion = "23.05";
}
