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
    nixpkgs.config.packageOverrides = pkgs: {
      steam = pkgs.steam.override {
        extraPkgs = pkgs: with pkgs; [
          gamescope
          mangohud
        ];
      };
    };
    programs.steam = mkIf cfg.steam.enable {
      enable = true;
      remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
      dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
      gamescopeSession.enable = true;
    };
    environment.systemPackages = mkIf cfg.minecraft.enable [
      pkgs.prismlauncher
      pkgs.mangohud
    ];
  };
}
