{ config, lib, pkgs, ...}: with lib; let
  cfg = config.santi-modules;
in {
  options.santi-modules.nushell.enable = mkEnableOption "Enable nushell as the default shell";
  config = mkIf cfg.nushell.enable {
    users.users.leonardo.shell = pkgs.nushell;
    home-manager.users.leonardo = {
      home.shell.enableNushellIntegration = true;
      programs.direnv = {
        enable = true;
        enableNushellIntegration = true;
        nix-direnv.enable = true;
      };
      programs.nushell = {
        enable = true;
        settings = {
          show_banner = false;
        };
        configFile.source = ./nushell.nu;
      };

    };
  };
}
