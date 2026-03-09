{ lib, config, ...}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.santi-modules;
in {
  imports = [   
    ./mu.nix
    ./zen.nix
    ./nushell.nix
    ./git.nix
    ./programs.nix
    ./mpv.nix
  ];
  options.santi-modules.home.enable = mkEnableOption "Enable home manager options";
  config = mkIf cfg.home.enable {
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
