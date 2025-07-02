{ config, lib, pkgs, ...}: with lib; let
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
        offlineimap.enable = true;
      };
      services.mbsync = {
        enable = true;
        frequency = "*:0/5";
      };
      accounts.email.accounts = let
        gmailAccount = { email, secret, primary ? false } : {
          inherit primary;
          address = email;
          userName = email;
          realName = "Leonardo Ribeiro Santiago";
          imap.host = "imap.gmail.com";
          smtp.host = "smtp.gmail.com";
          msmtp.enable = true;
          mu.enable = true;
          mbsync = {
            enable = true;
            create = "both";
            expunge = "both";
          };
          passwordCommand = "cat ${secret.path}";
        };
      in with config.age.secrets; {
        personal = gmailAccount {
          email = "leonardo.ribeiro.santiago@gmail.com";
          secret = personal-mail;
          primary = true;
        };
        university = gmailAccount {
          email = "leonardors@dcc.ufrj.br";
          secret = university-mail;
        };
        # supabase = gmailAccount {
        #   email = "leonardo.santiago@supabase.io";
        #   secret = supabase-mail;
        # };
      };
    };
  };
}
