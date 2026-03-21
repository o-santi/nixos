{ config, lib, inputs, pkgs, ... }: with lib; let
  cloudflared = config.santi-modules.services.cloudflared;
in {
  options.santi-modules.services = {
    cloudflared = {
      enable = mkEnableOption "Enable ddns service";
      fqdn = mkOption {
        type = types.str;
        default = "santi.net.br";
      };
    };
  };
  config = mkIf cloudflared.enable {
    networking.enableIPv6 = true;
    services.cloudflared = {
      enable = true;
      tunnels.iori = {
        default = "http_status:404";
        credentialsFile = "/var/lib/cloudflared/iori.json";
        ingress = {
          "${cloudflared.fqdn}" = "http://localhost:80";
          "git.${cloudflared.fqdn}" = "http://localhost:80";
        };
      };
    };
  };
}
