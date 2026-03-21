{ config, lib, inputs, pkgs, ... }: with lib; let
  inherit (config.santi-modules.services) immich cloudflared;
  
in {
  options.santi-modules.services.immich.enable = mkEnableOption "Enable immich photo server";
  config = mkIf immich.enable {
    services.immich = {
      enable = true;
      host = "localhost";
      port = 2283;
      openFirewall = true;
      machine-learning.enable = false;
    };
    services.nginx.virtualHosts."fotos.${cloudflared.fqdn}" = {
      locations."/".proxyPass = "http://localhost:2283";
    };
  };
}
