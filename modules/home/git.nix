{ config, lib, pkgs, ...}: with lib; let
  cfg = config.santi-modules;
in {
  options.santi-modules.git.enable = mkOption {
    description = "Enable git and its configuration";
    default = true;
    type = types.bool;
  };
  config = mkIf cfg.git.enable {
    home-manager.sharedModules = [(home-args: {
      programs.difftastic.enable = true;
      programs.git = {
        enable = true;
        lfs.enable = true;
        settings = {
          github.user = "o-santi";
          user = {
            name = "Leonardo Santiago";
            email = "leonardo.ribeiro.santiago@gmail.com";
            signingkey = "~/.ssh/id_ed25519";
          };
          color.ui = true;
          gpg.format = "ssh";
          commit.gpgsign = true;
          "merge \"mergigraf\"" = {
            name = "mergigraf";
            driver = "${pkgs.mergiraf}/bin/mergiraf merge --git %O %A %B -s %S -x %X -y %Y -p %P -l %L";
          };
        };
        attributes = [
          "* merge=mergigraf"
        ];
      };
    })];
  };
}
