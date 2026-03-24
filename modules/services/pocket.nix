{ config, lib, pkgs, ... }: with lib; let
  inherit (config.santi-modules.services) pocket cloudflared;
  pocket-local = "http://localhost:${toString pocket.port}";
  env-file = pkgs.writeTextFile {
    name = "pocket-id-env";
    text = ''
      APP_URL=https://${pocket.url}
      PORT=${toString pocket.port}
      ENCRYPTION_KEY_FILE=${config.age.secrets.pocket-id.path}
      TRUST_PROXY=true
      ANALYTICS_DISABLED=true
      VERSION_CHECK_DISABLED=true
    '';
  };
in {
  options.santi-modules.services.pocket = {
    enable = mkEnableOption "Enable pocket-id identity server";
    url = mkOption {
      type = types.str;
      default = "id.${cloudflared.fqdn}";
    };
    port = mkOption {
      type = types.int;
      default = 1411;
    };
  };
  config = mkIf pocket.enable {
    services.pocket-id = {
      enable = true;
      environmentFile = env-file;
    };
    systemd.services.pocket-id.serviceConfig.EnvironmentFile = lib.mkForce [
      env-file
    ];
    services.cloudflared.tunnels.iori.ingress = {
      ${pocket.url} = pocket-local;
    };
    age.secrets.pocket-id = {
      file = ../../secrets/pocket-id.age;
      owner = config.services.pocket-id.user;
      group = config.services.pocket-id.group;
    };
  };
}
