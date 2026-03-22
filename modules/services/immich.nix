{ config, lib, inputs, pkgs, ... }: with lib; let
  inherit (config.santi-modules.services) immich cloudflared;
in {
  options.santi-modules.services.immich = {
    enable = mkEnableOption "Enable immich photo server";
    port = mkOption {
      type = types.int;
      default = 2283;
    };
    url = mkOption {
      type = types.str;
      default = "fotos.${cloudflared.fqdn}";
    };
  };
  config = mkIf immich.enable {
    services.immich = {
      enable = true;
      host = "localhost";
      port = immich.port;
      openFirewall = true;
      machine-learning.enable = false;
    };
    services.nginx.virtualHosts.${immich.url} = {
      forceSSL = true;
      useACMEHost = cloudflared.fqdn;
      locations."/".proxyPass = "http://localhost:2283";
    };
  };
}
