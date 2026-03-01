{ config, lib, ...}: with lib; let
  cfg = config.santi-modules;
in {
  options.santi-modules.programs.enable = mkOption {
    description = "Enable zen browser from flake";
    type = types.bool;
    default = cfg.desktop-environment.enable;
  };
  config = mkIf cfg.programs.enable {
    home-manager.users.leonardo.home.packages = mkIf cfg.programs.enable
      (with pkgs; [
        legcord
        slack
        whatsapp-for-linux
        telegram-desktop
      ]);
  };
}
