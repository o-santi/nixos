{ config, lib, inputs, pkgs, ...}: with lib; let
  cfg = config.santi-modules;
in {
  imports = [
    inputs.agenix.nixosModules.default
    inputs.home-manager.nixosModules.home-manager
  ];
  options.santi-modules = { 
    default-user.enable = mkOption {
      type = types.bool;
      default = true;
      description = "Enables default user configuration and ssh access";
    };
    mu.enable = mkEnableOption "Enables mu, mbsync and msmtp";
  };
  config = mkIf config.santi-modules.default-user.enable {
    environment.systemPackages = with pkgs; [
      rage
      deploy-rs
      jujutsu
    ] ++ (if cfg.mu.enable then [ pkgs.parallel ] else []);
    users.mutableUsers = false;
    users.users.leonardo = {
      isNormalUser = true;
      description = "leonardo";
      extraGroups = [ "networkmanager" "wheel" ];
      shell = pkgs.bashInteractive;
      hashedPasswordFile = config.age.secrets.user-pass.path;
      openssh.authorizedKeys.keys = [ (builtins.readFile ../secrets/user-ssh-key.pub)] ++ builtins.attrValues (import ../secrets/host-pub-keys.nix);
    };
    age.secrets = let
      with-perms = name: {
        file = ../secrets/${name}.age;
        owner = "leonardo";
        group = "users";
      };
    in {
      user-pass = with-perms "user-pass";
      user-ssh-key = {
        file = ../secrets/user-ssh-key.age;
        path = "/home/leonardo/.ssh/id_ed25519";
        owner = "leonardo";
        group = "users";
      };
    } // (optionalAttrs cfg.mu.enable (let
      mails = ["work-mail" "personal-mail" "university-mail"];
      mail-cfg = map (n: {name = n; value = with-perms n;}) mails;
    in
      listToAttrs mail-cfg))
    // (optionalAttrs cfg.services.ddns.enable {
      cloudflare = with-perms "cloudflare";
    }) // (optionalAttrs cfg.emacs.enable {
      authinfo = with-perms "authinfo";
    });
    programs.ssh.startAgent = true;
    services.openssh = {
      enable = true;
      settings = {
        KbdInteractiveAuthentication = false;
        PasswordAuthentication = false;
      };
    };
    home-manager = {
      backupFileExtension = "backup";
      useGlobalPkgs = true;
      useUserPackages = true;
      users.leonardo = {
        imports = [ (import ./gnome/gnome-config.nix config.santi-modules) ];
        home = {
          stateVersion = "23.05";
          homeDirectory = "/home/leonardo";
          file.".ssh/id_ed25519.pub".source = ../secrets/user-ssh-key.pub;
          # file.".mozilla/firefox/leonardo/chrome/firefox-gnome-theme" =  mkIf cfg.firefox.enable { source = inputs.firefox-gnome-theme; };
          packages = lib.optionals cfg.desktop-environment.enable (with pkgs; [
            vesktop
            slack
            whatsapp-for-linux
            telegram-desktop
            inputs.zen-browser.packages.${system}.default
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
            diff-so-fancy.enable = true;
            extraConfig = {
              user = {
                name = "Leonardo Santiago";
                email = "leonardo.ribeiro.santiago@gmail.com";
                signingkey = "~/.ssh/id_ed25519";
              };
              color.ui = true;
              gpg.format = "ssh";
              commit.gpgsign = true;
            };
          };
          mu.enable = cfg.mu.enable;
          msmtp.enable = cfg.mu.enable;
          mbsync.enable = cfg.mu.enable;
        };
        services.mbsync = mkIf cfg.mu.enable {
          enable = true;
          frequency = "*:0/5";
        };
        accounts.email.accounts = mkIf cfg.mu.enable {
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
  };
}
