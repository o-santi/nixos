{ config, lib, pkgs, ... }: with lib; let
  inherit (config.santi-modules.services) blog cloudflared cgit;
  env = pkgs.buildEnv {
    name = "post-receive-env";
    paths = [
      pkgs.git
      pkgs.coreutils
      pkgs.gnutar
      pkgs.xz
    ];
  };
  post-receive = pkgs.writeShellScript "post-receive" ''
    export PATH=${env}/bin
    set -ex
    
    GIT_DIR=$(${pkgs.git}/bin/git rev-parse --git-dir 2>/dev/null)
    if [ -z "$GIT_DIR" ]; then
            echo >&2 "fatal: post-receive: GIT_DIR not set"
            exit 1
    fi
    
    TMPDIR=$(mktemp -d)
    function cleanup() {
      rm -rf "$TMPDIR"
    }
    trap cleanup EXIT
    
    ${pkgs.git}/bin/git clone "$GIT_DIR" "$TMPDIR"
    unset GIT_DIR
    cd "$TMPDIR"
    ${pkgs.hugo}/bin/hugo --destination ${blog.local-path}
  '';
in {
  options.santi-modules.services = {
    blog = {
      enable = mkEnableOption "Enable blog hosting";
      url = mkOption {
        type = types.str;
        default = cloudflared.fqdn;
        description = "Url to serve blog on";
      };
      local-path = mkOption {
        type = types.str;
        default = "/server/blog";
      };
    };
  };
  config = mkIf blog.enable {
    networking.firewall.allowedTCPPorts = [ 80 443 ];
    services.nginx = {
      enable = true;
      recommendedBrotliSettings = true;
      recommendedGzipSettings   = true;
      # recommendedZstdSettings   = true; # Unmaintained.

      recommendedOptimisation   = true;
      recommendedProxySettings  = true;
      recommendedTlsSettings    = true;
      virtualHosts.${blog.url} = {
        addSSL = true;
        enableACME = true;
        root = blog.local-path;
      };
    };
    security.acme = {
      acceptTerms = true;
      certs.${blog.url}.email = "leonardo.ribeiro.santiago@gmail.com";
    };
    systemd.tmpfiles.rules = [
      "d ${blog.local-path} 0755 git users"
    ];
    systemd.services."blog-prepare-git-repo" = {
      wantedBy = [ "multi-user.target" ];
      path = [
        pkgs.git
      ];
      script = ''
        set -ex
        cd ${cgit.git-repo-path}
        chmod +rX ${blog.local-path}
        test -e blog || git init --bare blog
        ln -nsf ${post-receive} blog/hooks/post-receive
      '';
      serviceConfig = {
        Kind = "one-shot";
        User = "git";
      };
    };
  };
}
