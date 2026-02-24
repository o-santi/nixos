{ config, lib, inputs, pkgs, ... }: with lib; let
  cfg = config.santi-modules.services;
in {
  options.santi-modules.services.syncthing.enable = mkEnableOption "Enable syncthing instance";
  config = mkIf cfg.syncthing.enable {
    services.syncthing = {
      enable = true;
      openDefaultPorts = true;
      guiAddress = "iori.stomatopod-vibes.ts.net:8384";
      settings = {
        gui = {
          theme = "black";
        };
      };
    };
    networking.firewall.allowedTCPPorts = [ 8384 ];
  };
}
