# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ lib, inputs, modulesPath, ... }:

{
  imports = [ # Include the results of the hardware scan.
    inputs.nixos-hardware.nixosModules.raspberry-pi-4
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  santi-modules = {
    default-user.enable = true;
    basic.enable = true;
    font-config.enable = false;
    services = {
      ddns.enable = true;
      blog.enable = true;
      cgit.enable = true;
    };
  };
  
  boot = {
    loader.grub.enable = false;
    loader.generic-extlinux-compatible.enable = true;
    initrd.availableKernelModules = [ "xhci_pci" ];
  };

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/44444444-4444-4444-8888-888888888888";
    fsType = "ext4";
  };
  
  networking = {
    hostName = "iori"; # Define your hostname.
    useDHCP = lib.mkDefault true;
  };
  nixpkgs.hostPlatform = lib.mkDefault "aarch64-linux";
  system.stateVersion = "24.05"; # Did you read the comment?
}
