{ pkgs, config, inputs, ... }:
let
  hosts-pub-keys = import ../secrets/host-pub-keys.nix;
  host-key = hosts-pub-keys.${config.networking.hostName};
in
{
  imports = [
    ../modules/gnome.nix
    ../modules/emacs/emacs.nix
  ];
  config = {
    nix = {
      settings = {
        trusted-users = [ "root" "leonardo" ];
        experimental-features = "nix-command flakes";
        auto-optimise-store = true;
      };
      gc = {
        automatic = true;
        dates = "weekly";
        options = "--delete-older-than 30d";
      };
    };

    environment.systemPackages = with pkgs;[
      prismlauncher
      rage
    ];
    
    nixpkgs = {
      config.allowUnfree = true;
      config.allowUnfreePredicate = _: true;
    };
    programs.bash = {
      vteIntegration = true;
      enableLsColors = true;
      completion.enable = true;
      promptInit =
        ''
          PS1="\[\033[1;95m\][\h]\[\033[0m\] \[\033[0;32m\]\w\[\033[0m\] :: "
          [ -n "$EAT_SHELL_INTEGRATION_DIR" ] && source "$EAT_SHELL_INTEGRATION_DIR/bash"
        '';
    };
    fonts = {
      fontconfig = {
        enable = true;
        defaultFonts = {
          monospace =  [ "Iosevka" "IPAGothic" ];
          serif = [ "DejaVu Serif" "IPAPMincho" ];
        };
      };
      packages = with pkgs; [
        (nerdfonts.override { fonts = [ "Iosevka" "FiraCode" ]; })
        ipafont
        kochi-substitute
        dejavu_fonts
      ];
    };
    
    programs.steam = {
      enable = true;
      remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
      dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
    };
    programs.direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
    programs.ssh.startAgent = true;
    services.pipewire = {
      enable = true;
      extraConfig.pipewire = {
        "context.properties"."module.x11.bell" = false;
      };
    };
    services.openssh = {
      enable = true;
      settings = {
        KbdInteractiveAuthentication = false;
        PasswordAuthentication = false;
      };
    };
    users.mutableUsers = false;
    users.users.leonardo = {
      isNormalUser = true;
      description = "leonardo";
      extraGroups = [ "networkmanager" "wheel" ];
      shell = pkgs.bashInteractive;
      hashedPasswordFile = config.age.secrets.user-pass.path;
      openssh.authorizedKeys.keys = [ (builtins.readFile ../secrets/user-ssh-key.pub)] ++  builtins.attrValues (hosts-pub-keys);
    };

    age = {
      secrets = {
        user-ssh-key = {
          file = ../secrets/user-ssh-key.age;
          path = "/home/leonardo/.ssh/id_ed25519";
          owner = "leonardo";
          group = "users";
        };
      } // (builtins.foldl' (acc: filename: acc // {
        ${filename} = {
          file = ../secrets/${filename}.age;
          owner = "leonardo";
          group = "users";
        };
      }) {} [ "personal-mail" "work-mail" "university-mail" "authinfo" "user-pass" ]);
    };
    services.gnome.gnome-browser-connector.enable = true;
    home-manager = {
      backupFileExtension = "backup";
      useGlobalPkgs = true;
      useUserPackages = true;
      users.leonardo = { pkgs, ... } : {
        imports = [ ./../modules/gnome-config.nix ];
        home = {
          file.".ssh/id_ed25519.pub".source = ../secrets/user-ssh-key.pub;
          file.".mozilla/firefox/leonardo/chrome/firefox-gnome-theme".source = inputs.firefox-gnome-theme;
          username = "leonardo";
          homeDirectory = "/home/leonardo";
          stateVersion = "23.05";
          sessionVariables.GTK_THEME = "Adwaita-dark";
          packages = with pkgs; [
            discord
            slack
            whatsapp-for-linux
            telegram-desktop
          ];
        };
        
        programs = {
          firefox = {
            enable = true;
            package = pkgs.firefox.override {  # nixpkgs' firefox/wrapper.nix
              nativeMessagingHosts = [
                pkgs.gnome-browser-connector
              ];
            };
            profiles.leonardo = {
              userChrome = ''
                @import "firefox-gnome-theme/userChrome.css";
              '';
              userContent = ''
                @import "firefox-gnome-theme/userContent.css";
              '';
              settings = {
                "toolkit.legacyUserProfileCustomizations.stylesheets" = true; # Enable customChrome.cs
                "browser.uidensity" = 0; # Set UI density to normal
                "svg.context-properties.content.enabled" = true; # Enable SVG context-propertes
                # firefox-gnome-theme
                "gnomeTheme.activeTabContrast" = true;
                "gnomeTheme.hideWebrtcIndicator" = true;
                "gnomeTheme.bookmarksToolbarUnderTabs" = true;
                "gnomeTheme.hideSingleTab" = true;
              };
            };
            policies = {
              DisableTelemetry = true;
              DisableFirefoxStudies = true;
              EnableTrackingProtection = {
                Value= true;
                Locked = true;
                Cryptomining = true;
                Fingerprinting = true;
              };
              DisablePocket = true;
              DisableFirefoxAccounts = true;
              DisableAccounts = true;
              DisableFirefoxScreenshots = true;
              OverrideFirstRunPage = "";
              OverridePostUpdatePage = "";
              DontCheckDefaultBrowser = true;
              ExtensionSettings = {
                "*".installation_mode = "blocked"; # blocks all addons except the ones specified below
                # uBlock Origin:
                "uBlock0@raymondhill.net" = {
                  install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
                  installation_mode = "force_installed";
                };
              };
            };
          };
          bash = {
            enable = true;
            enableVteIntegration = true;
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
    
  };
}
