{ config, lib, inputs, pkgs, ... }: with lib; let
  cfg = config.santi-modules.services;
in {
  options.santi-modules.services.tailscale = {
    enable = mkEnableOption "Enable tailscale instance";
    hostname = mkOption {
      type = types.str;
      default = "iori.stomatopod-vibes.ts.net";
    };
  };
  config = mkIf cfg.tailscale.enable {
    services.tailscale.enable = true;
  };
}
