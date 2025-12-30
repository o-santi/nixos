{ lib, config, ...}: let
  inherit (lib) mkIf mkEnableOption;
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
    };
  };
}
