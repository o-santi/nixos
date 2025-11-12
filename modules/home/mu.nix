{ config, lib, pkgs, ...}: with lib; let
  cfg = config.santi-modules;
  mbsync-oauth2 = pkgs.isync.override {
    withCyrusSaslXoauth2 = true;
  };
in {
  options.santi-modules.mu.enable = mkEnableOption "Enables mu, mbsync and msmtp";
  config = mkIf cfg.mu.enable {
    environment.systemPackages = [
      pkgs.pizauth
    ];
    home-manager.users.leonardo = {
      programs = {
        mu.enable = true;
        msmtp.enable = true;
        mbsync = {
          enable = true;
          package = mbsync-oauth2;
        };
        offlineimap.enable = true;
      };
      services.mbsync = {
        enable = true;
        frequency = "*:0/5";
        package = mbsync-oauth2;
      };
      services.pizauth = {
        enable = true;
        accounts.supabase = {
          authUri = "https://accounts.google.com/o/oauth2/auth";
          loginHint = "leonardo.santiago@supabase.io";
          tokenUri = "https://oauth2.googleapis.com/token";
          clientId = "406964657835-aq8lmia8j95dhl1a2bvharmfk3t1hgqj.apps.googleusercontent.com";
          clientSecret = "kSmqreRr0qwBWJgbf5Y-PjSU";
          scopes = ["https://mail.google.com/"];
        };
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
            extraConfig.account = {
              AuthMechs = "PLAIN";
            };
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
        supabase =  {
          address = "leonardo.santiago@supabase.io";
          userName = "leonardo.santiago@supabase.io";
          realName = "Leonardo Ribeiro Santiago";
          imap.host = "imap.gmail.com";
          smtp.host = "smtp.gmail.com";
          msmtp.enable = true;
          mu.enable = true;
          mbsync = {
            enable = true;
            create = "both";
            expunge = "both";
            extraConfig.account = {
              AuthMechs = "XOAUTH2";
            };
          };
          passwordCommand = "pizauth show supabase";
        };
      };
    };
  };
}
