{ config, lib, pkgs, ...}: with lib; {
  options.santi-modules.services.ddns.enable = mkEnableOption "Enable ddns service";
  config = mkIf config.santi-modules.services.ddns.enable {
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
