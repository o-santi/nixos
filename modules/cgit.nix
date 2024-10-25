{ config, lib, pkgs, ...}: with lib; {
  options.santi-modules.services.cgit.enable = mkEnableOption "Enable cgit instance";
  config = mkIf config.santi-modules.services.cgit.enable {
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
      user = "root";
      group = "root";
      settings = {
        readme = ":README.org";
        root-title = "index";
        root-desc = "public repositories for santi.net.br";
        about-filter = toString org2html;
        enable-git-config = true;
        enable-html-cache = false;
        enable-blame = true;
        enable-log-linecount = true;
        enable-index-links = true;
        enable-index-owner = false;
        enable-commit-graph = true;
        remove-suffix = true;
      };
      scanPath = "/home/leonardo";
    };
  };
}
