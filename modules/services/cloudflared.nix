{ config, lib, ... }: with lib; let
  inherit (config.santi-modules.services) cloudflared;
in {
  options.santi-modules.services.cloudflared = {
    enable = mkEnableOption "Enable ddns service";
    fqdn = mkOption {
      type = types.str;
      default = "santi.net.br";
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
    security.acme = {
      acceptTerms = true;
      defaults = {
        email = "leonardo.ribeiro.santiago@gmail.com";
      };
      certs.${cloudflared.fqdn} = {
        webroot = null;
        extraDomainNames = [ "*.${cloudflared.fqdn}" ];
        group = "nginx";
        dnsResolver = "1.1.1.1"; # cloudflare dns
        dnsProvider = "cloudflare";
        environmentFile = config.age.secrets.cloudflare-api-token.path;
      };
    };
  };
}
