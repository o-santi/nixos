# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, inputs, modulesPath,  ... }: {
  imports = [
    inputs.nixos-hardware.nixosModules.framework-13-7040-amd
    ./disko.nix
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  hardware.facter.reportPath = ./facter.json;
  
  santi-modules = {
    desktop-environment.enable = true;
    has-touchpad = true;
  };
  # Bootloader.
  boot = {
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
    initrd = {
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
        naturalScrolling = true;
        tappingButtonMap = "lrm";
      };
    };
  };

  programs.nix-ld.enable = true;
  virtualisation.docker = {
    enable = true;
  };

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  system.stateVersion = "23.11"; 
}
