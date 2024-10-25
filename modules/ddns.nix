{ config, lib, ...}: with lib; {
  options.santi-modules.services.ddns.enable = mkEnableOption "Enable ddns service";
  config = mkIf config.santi-modules.services.ddns.enable {
    networking.enableIPv6 = true;
    services.cloudflared = {
      enable = true;
      tunnels.iori = {
        default = "http_status:404";
        credentialsFile = "/var/lib/cloudflared/iori.json";
        ingress = {
          "santi.net.br" = "http://localhost:80";
        };
      };
    };
    services.inadyn = {
      enable = true;
      user = "leonardo";
      group = "users";
      settings.provider."cloudflare.com" = {
        hostname="santi.net.br";
        username="santi.net.br";
        proxied = false;
        include = config.age.secrets.cloudflare.path;
      };
    };
  };
}
