{ config, lib, inputs, pkgs, ... }: with lib; let
  inherit (config.santi-modules.services) vaultwarden cloudflared;
in {
  options.santi-modules.services.vaultwarden = {
    enable = mkEnableOption "Enable vaulwarden password manager server";
    port = mkOption {
      type = types.int;
      default = 8222;
    };
    url = mkOption {
      type = types.str;
      default = "vault.${cloudflared.fqdn}";
    };
  };
  config = mkIf vaultwarden.enable {
    services.vaultwarden = {
      enable = true;
      domain = "localhost";
      config = {
        ROCKET_PORT = vaultwarden.port;
      };
    };
    services.nginx.virtualHosts.${vaultwarden.url} = {
      forceSSL = true;
      useACMEHost = cloudflared.fqdn;
      locations."/" = {
        proxyPass = "http://localhost:${toString vaultwarden.port}";
        proxyWebsockets = true;
      };
    };
  };
}
