{ pkgs, config, inputs, ... }:
{
  imports = [
    ../modules/gnome.nix
    ../modules/emacs/emacs.nix
    ../modules/s3nixcache-mixrank.nix
  ];
  config = {
    nix = {
      package = pkgs.nixVersions.nix_2_20;
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

    environment.systemPackages = [
      pkgs.prismlauncher
    ];
    
    nixpkgs = {
      config.allowUnfree = true;
      config.allowUnfreePredicate = _: true;
    };
    programs.bash = {
      vteIntegration = true;
      enableLsColors = true;
      enableCompletion = true;
      promptInit =
        ''
        PS1="\e[0;95m\[[\h]\]\e[0m \e[0;32m\[\w\]\e[0m :: "
        vterm_printf() {
            if [ -n "$TMUX" ] && ([ "''${TERM%%-*}" = "tmux" ] || [ "''${TERM%%-*}" = "screen" ]); then
                # Tell tmux to pass the escape sequences through
                printf "\ePtmux;\e\e]%s\007\e\\" "$1"
            elif [ "''${TERM%%-*}" = "screen" ]; then
                # GNU screen (screen, screen-256color, screen-256color-bce)
                printf "\eP\e]%s\007\e\\" "$1"
            else
                printf "\e]%s\e\\" "$1"
            fi
        }
        vterm_prompt_end(){
            vterm_printf "51;A$(whoami)@$(hostname):$(pwd)"
        }
        PS1=$PS1'\[$(vterm_prompt_end)\]'
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
    programs.ssh = {
      startAgent = true;
      forwardX11 = true;
    };
    services.pipewire = {
      enable = true;
      extraConfig.pipewire = {
        "context.properties"."module.x11.bell" = false;
      };
    };
    services.openssh.enable = true;
    # services.xserver.xkb.layout
    # services.xserver.xkb.variant
    users.users.leonardo = {
      isNormalUser = true;
      description = "leonardo";
      extraGroups = [ "networkmanager" "wheel" ];
      shell = pkgs.bashInteractive;
      hashedPassword = "$y$j9T$NT9Ymktl8npD5RomDyBmK0$YfrrP0fcHRPcJZAAO.g8pRsSBoYvIq2aBBxBAHIesU2";
    };

    age.secrets = {
      personal-mail = {
        file = ../secrets/personal-mail.age;
        owner = "1000";
        group = "100";
      };
      work-mail = {
        file = ../secrets/work-mail.age;
        owner = "1000";
        group = "100";
      };
      university-mail = {
        file = ../secrets/university-mail.age;
        owner = "1000";
        group = "100";
      };
      authinfo = {
        file = ../secrets/authinfo.age;
        owner = "1000";
        group = "100";
      };
    };
    services.gnome.gnome-browser-connector.enable = true;
    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
      users.leonardo = { pkgs, ... } : {
        imports = [ ./../modules/gnome-config.nix ];
        home = {
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
          direnv = {
            enable = true;
            enableBashIntegration = true;
            nix-direnv.enable = true;
          };
          git = {
            enable = true;
            diff-so-fancy.enable = true;
            extraConfig = {
              user.name = "Leonardo Santiago";
              user.email = "leonardo@mixrank.com";
              color.ui = true;
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
