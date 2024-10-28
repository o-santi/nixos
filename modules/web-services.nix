{ config, lib, inputs, pkgs, ... }: with lib; let
  cfg = config.santi-modules.services;
  git-repo-path = "/server/git-repos";
  cgit-config = mkIf cfg.cgit.enable {
    environment.systemPackages = [
      pkgs.git
    ];
    users.users = {
      git = {
        description = "git user";
        isNormalUser = true;
        home = git-repo-path;
        openssh.authorizedKeys.keys = [ (builtins.readFile ../secrets/user-ssh-key.pub)] ++ builtins.attrValues (import ../secrets/host-pub-keys.nix);
      };
    };
    systemd.tmpfiles.rules = [
      "d ${git-repo-path} 0755 git users -"
    ];
    services.cgit.santi = let
      org2html = pkgs.writeShellScript "org2md" ''
        ${pkgs.pandoc}/bin/pandoc \
          --from org \
          --to html5 \
          --sandbox=true \
          --html-q-tags \
          --ascii \
          --standalone \
          --wrap=auto \
          --embed-resources \
          -M document-css=false
      '';
    in {
      enable = true;
      scanPath = git-repo-path;
      nginx.virtualHost = "git.santi.net.br";
      settings = {
        readme = ":README.org";
        root-title = "index";
        root-desc = "public repositories for santi.net.br";
        about-filter = toString org2html;
        source-filter = "${pkgs.cgit}/lib/cgit/filters/syntax-highlighting.py";
        enable-git-config = true;
        enable-html-cache = false;
        enable-blame = true;
        enable-log-linecount = true;
        enable-index-links = true;
        enable-index-owner = false;
        enable-commit-graph = true;
        remove-suffix = true;
      };
    };
  };
  blog-config = let
    blog-public-path = "/server/blog";
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
      ${pkgs.hugo}/bin/hugo --destination ${blog-public-path}
    '';
  in mkIf cfg.blog.enable {
    networking.firewall.allowedTCPPorts = [ 80 443 ];
    # TODO: enable SSL
    services.nginx = {
      enable = true;
      virtualHosts.${cfg.blog.url} = {
        addSSL = true;
        enableACME = true;
        root = blog-public-path;
      };
    };
    security.acme = {
      acceptTerms = true;
      certs.${cfg.blog.url}.email = "leonardo.ribeiro.santiago@gmail.com";
    };
    systemd.tmpfiles.rules = [
      "d ${blog-public-path} 0755 git users -"
    ];
    systemd.services."blog-prepare-git-repo" = {
      wantedBy = [ "multi-user.target" ];
      path = [
        pkgs.git
      ];
      script = ''
        set -ex
        cd ${git-repo-path}
        chmod +rX ${blog-public-path}
        test -e blog || git init --bare blog
        ln -nsf ${post-receive} blog/hooks/post-receive
      '';
      serviceConfig = {
        Kind = "one-shot";
        User = "git";
      };
    };
  };
  
  ddns-config = mkIf cfg.ddns.enable {
    networking.enableIPv6 = true;
    services.cloudflared = {
      enable = true;
      tunnels.iori = {
        default = "http_status:404";
        credentialsFile = "/var/lib/cloudflared/iori.json";
        ingress = {
          "santi.net.br" = "http://localhost:80";
          "git.santi.net.br" = "http://localhost:80";
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
in {
  options.santi-modules.services = {
    blog = {
      enable = mkEnableOption "Enable blog hosting";
      url = mkOption {
        type = types.str;
        default = "santi.net.br";
        description = "Url to serve blog on";
      };
    };
    cgit.enable = mkEnableOption "Enable cgit instance";
    ddns.enable = mkEnableOption "Enable ddns service";
  };
  config = mkMerge [
    cgit-config
    blog-config
    ddns-config
  ];
}
