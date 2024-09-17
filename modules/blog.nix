{ config, lib, inputs, pkgs, ... }: with lib; let
  cfg = config.santi-modules.services.blog;
  blog = pkgs.stdenv.mkDerivation {
    name="hugo-blog";
    src = inputs.blog;
    buildInputs = [ pkgs.hugo ];
    buildPhase = ''
      mkdir $out
      hugo --destination $out
    '';
  };
in {
  options.santi-modules.services.blog = {
    enable = mkEnableOption "Enable blog hosting";
    url = mkOption {
      type = types.str;
      default = "santi.net.br";
      description = "Url to serve blog on";
    };
  };
  config = mkIf cfg.enable {
    networking.firewall.allowedTCPPorts = [ 80 443 ];
    # TODO: enable SSL
    services.nginx = {
      enable = true;
      virtualHosts.${cfg.url} = {
        addSSL = true;
        enableACME = true;
        root = blog;
      };
    };
    security.acme = {
      acceptTerms = true;
      certs."santi.net.br".email = "leonardo.ribeiro.santiago@gmail.com";
    };
  };
}
