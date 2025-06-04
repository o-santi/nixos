{ config, lib, inputs, pkgs, ...}: with lib; let
  cfg = config.santi-modules;
in {
  imports = [
    inputs.home-manager.nixosModules.home-manager
    ./mu.nix
    ./zen.nix
  ];
  config = mkIf cfg.default-user.enable {
    home-manager = {
      backupFileExtension = "backup";
      useGlobalPkgs = true;
      useUserPackages = true;
      users.leonardo = {
        home = {
          stateVersion = "23.05";
          homeDirectory = "/home/leonardo";
          packages = lib.optionals cfg.desktop-environment.enable (with pkgs; [
            legcord
            slack
            whatsapp-for-linux
            telegram-desktop
          ]);
        };
        programs = {
          bash = {
            enable = true;
            enableCompletion = true;
            initExtra = ''
              shopt -s -q autocd
              shopt -s no_empty_cmd_completion
            '';
          };
          fzf = {
            enable = true;
            enableBashIntegration = true;
          };
          git = {
            enable = true;
            lfs.enable = true;
            difftastic.enable = true;
            extraConfig = {
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
        };
      };
    };
  };  
}
