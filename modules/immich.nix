{ config, lib, inputs, pkgs, ... }: with lib; let
  cfg = config.santi-modules.services;
in {
  options.santi-modules.services.immich.enable = mkEnableOption "Enable immich photo server";
  config = mkIf cfg.immich.enable {
    services.immich = {
      enable = true;
      host = "iori.stomatopod-vibes.ts.net";
      openFirewall = true;
      machine-learning.enable = false;
    };
  };
}
