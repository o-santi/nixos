{ config, pkgs, inputs, ... }:
{
  imports = [
    ./../gnome.nix
    inputs.emacs.nixosModules.x86_64-linux.default
  ];
  config = {
    programs.zsh.enable = true;

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
    };

    users.users.leonardo = {
      isNormalUser = true;
      description = "leonardo";
      extraGroups = [ "networkmanager" "wheel" ];
      shell = pkgs.zsh;
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
          zsh = {
            enable = true;
            oh-my-zsh = {
              enable = true;
              plugins = [
                "sudo"
                "git"
                "fzf"
                "rust"
              ];
            };
          };
          fzf = {
            enable = true;
            enableZshIntegration = true;
          };
          starship = {
            enable = true;
            enableZshIntegration = true;
          };
          direnv = {
            enable = true;
            enableZshIntegration = true;
            nix-direnv.enable = true;
          };
          kitty = {
            enable = true;
            shellIntegration.enableZshIntegration = true;
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
