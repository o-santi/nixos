{ config, pkgs, inputs, ... }:
{
  imports = [
    ./../gnome.nix
    inputs.emacs.nixosModules.x86_64-linux.default
  ];
  config = {
    programs.bash = {
      vteIntegration = true;
      enableLsColors = true;
      enableCompletion = true;
    };
    fonts = {
      fontconfig.enable = true;
      packages = [(pkgs.nerdfonts.override { fonts = [ "Iosevka" "FiraCode" ]; })];
    };
    
    programs.steam = {
      enable = true;
      remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
      dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
    };
    services.openssh.enable = true;

    programs.ssh = {
      forwardX11 = true;
      startAgent = true;
      extraConfig = ''
        Host github.com
        IdentityFile ~/.ssh/github
        StrictHostKeyChecking no

        Host gitlab.com
        IdentityFile ~/.ssh/gitlab
        IdentitiesOnly yes
        StrictHostKeyChecking no
      '';
    };

    users.users.leonardo = {
      isNormalUser = true;
      description = "leonardo";
      extraGroups = [ "networkmanager" "wheel" ];
      shell = pkgs.bashInteractive;
    };
    
    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
      users.leonardo = { config, pkgs, ... } : {
        home = {
          username = "leonardo";
          homeDirectory = "/home/leonardo";
          stateVersion = "23.05";
          sessionVariables.GTK_THEME = "Adwaita-dark";
          packages = with pkgs; [
            discord
            slack
            whatsapp-for-linux
          ];
        };
        programs = {
          bash = {
            enable = true;
            enableVteIntegration = true;
            enableCompletion = true;
            initExtra = ''
              shopt -s -q autocd
              shopt -s no_empty_cmd_completion
            '';
          };
          oh-my-posh = {
            enable = true;
            enableBashIntegration = true;
            useTheme = "catppuccin";
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
          kitty = {
            enable = true;
            shellIntegration.enableBashIntegration = true;
            settings = {
              enable_audio_bell = false;
              background_opacity = "0.7";
            };
          };
          firefox.enable = true;
          git = {
            enable = true;
            diff-so-fancy.enable = true;
            extraConfig = {
              user.name = "Leonardo Santiago";
              user.email = "leonardo@mixrank.com";
              color.ui = true;
            };
          };
        };
      };
    };
    
  };
}
