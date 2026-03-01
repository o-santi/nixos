{ lib, config, pkgs, ...}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.santi-modules;
in {
  imports = [   
    ./mu.nix
    ./zen.nix
    ./nushell.nix
    ./git.nix
    ./programs.nix
  ];
  options.santi-modules.home.enable = mkEnableOption "Enable zen browser from flake";
  config = mkIf config.santi-modules.home.enable {
    home-manager = {
      backupFileExtension = "backup";
      useGlobalPkgs = true;
      useUserPackages = true;
      users.leonardo = {
        home = {
          stateVersion = "23.05";
          homeDirectory = "/home/leonardo";
        };
      };
    };
  };
}
