{ config, lib, inputs, pkgs, ... }: with lib; let
  inherit (config.santi-modules.services) cgit cloudflared;
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
  options.santi-modules.services = {
    cgit = {
      enable = mkEnableOption "Enable cgit instance";
      git-repo-path = mkOption {
        type = types.str;
        default = "/server/git-repos";
      };
    };
  };
  config = mkIf cgit.enable {
    environment.systemPackages = [
      pkgs.git
    ];
    users.users.git = {
      description = "git user";
      isNormalUser = true;
      home = cgit.git-repo-path;
      openssh.authorizedKeys.keys = [ (builtins.readFile ../../secrets/user-ssh-key.pub)] ++ builtins.attrValues (import ../../secrets/host-pub-keys.nix);
    };
    systemd.tmpfiles.rules = [
      "d ${cgit.git-repo-path} 0755 git users"
    ];
    services.cgit.santi = {
      enable = true;
      scanPath = cgit.git-repo-path;
      nginx.virtualHost = "git.${cloudflared.fqdn}";
      gitHttpBackend.checkExportOkFiles = false;
      settings = {
        readme = ":README.org";
        root-title = "index";
        root-desc = "public repositories for ${cloudflared.fqdn}";
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
}
