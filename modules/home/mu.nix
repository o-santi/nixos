{ config, lib, ...}: with lib; let
  cfg = config.santi-modules;
in {
  options.santi-modules.mu.enable = mkEnableOption "Enables mu, mbsync and msmtp";
  config = mkIf cfg.mu.enable {
    environment.systemPackages = [
      pkgs.parallel
    ];
    home-manager.users.leonardo = {
      programs = {
        mu.enable = true;
        msmtp.enable = true;
        mbsync.enable = true;
      };
      services.mbsync = {
        enable = true;
        frequency = "*:0/5";
      };
      accounts.email.accounts = {
        personal = {
          address = "leonardo.ribeiro.santiago@gmail.com";
          userName = "leonardo.ribeiro.santiago@gmail.com";
          imap.host = "imap.gmail.com";
          smtp.host = "smtp.gmail.com";
          primary = true;
          realName = "Leonardo Ribeiro Santiago";
          mbsync = {
            enable = true;
            create = "both";
            expunge = "both";
          };
          msmtp.enable = true;
          mu.enable = true;
          passwordCommand = "cat ${config.age.secrets.personal-mail.path}";
        };
        university = {
          address = "leonardors@dcc.ufrj.br";
          userName = "leonardors@dcc.ufrj.br";
          imap.host = "imap.gmail.com";
          smtp.host = "smtp.gmail.com";
          realName = "Leonardo Ribeiro Santiago";
          mbsync = {
            enable = true;
            create = "both";
            expunge = "both";
          };
          msmtp.enable = true;
          mu.enable = true;
          passwordCommand = "cat ${config.age.secrets.university-mail.path}";
        };
        work = {
          address = "leonardo@mixrank.com";
          userName = "leonardo@mixrank.com";
          imap.host = "imap.gmail.com";
          smtp.host = "smtp.gmail.com";
          realName = "Leonardo Ribeiro Santiago";
          mbsync = {
            enable = true;
            create = "both";
            expunge = "both";
          };
          msmtp.enable = true;
          mu.enable = true;
          passwordCommand = "cat ${config.age.secrets.work-mail.path}";
        };
      };
    };
  };
}
