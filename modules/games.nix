{ config, lib, pkgs, ... }: let
  cfg = config.santi-modules;
in with lib; {
  options.santi-modules = {
    games.enable = mkEnableOption "Enable all games";
    steam.enable = mkOption {
      description = "Enable steam installation";
      default = cfg.games.enable;
      type = types.bool;
    };
    minecraft.enable = mkOption {
      description = "Enable minecraft launcher";
      default = cfg.games.enable;
      type = types.bool;
    };
  };
  config = {
    programs.steam = mkIf cfg.steam.enable {
      enable = true;
      remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
      dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
    };
    environment.systemPackages = mkIf cfg.minecraft.enable [
      pkgs.prismlauncher
    ];
  };
}
