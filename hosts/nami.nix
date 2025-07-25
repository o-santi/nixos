{ config, pkgs, ...}: {
  santi-modules = {
    desktop-environment.enable = true;
  };
  nixpkgs.hostPlatform = "aarch64-darwin";
}
