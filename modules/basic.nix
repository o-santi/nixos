{ config, lib, pkgs, inputs, ...}: with lib; {
  options.santi-modules = {
    basic.enable = mkOption {
      type = types.bool;
      default = true;
      description = "Enables basic configuration on nix, nixpkgs and bash prompt.";
    };
    has-touchpad = mkOption {
      type = types.bool;
      default = false;
      description = "Whether a given device has support for touchpad";
    };
  };
  config = mkIf config.santi-modules.basic.enable {
    documentation.nixos.enable = false;
    nix = {
      registry.nixpkgs.to = {
        type = "path";
        path = inputs.nixpkgs;
      };
      package = pkgs.lib.mkForce pkgs.nixVersions.nix_2_28;
      settings = {
        trusted-users = [ "root" "leonardo" ];
        auto-optimise-store = true;
        experimental-features = [ "nix-command" "flakes" ];
      };
      gc = {
        automatic = true;
        dates = "weekly";
        options = "--delete-older-than 30d";
      };
    };
    system.switch.enableNg = true;

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
          vterm_printf() {
              if [ -n "$TMUX" ] && ([ "$${TERM%%-*}" = "tmux" ] || [ "$${TERM%%-*}" = "screen" ]); then
                  # Tell tmux to pass the escape sequences through
                  printf "\ePtmux;\e\e]%s\007\e\\" "$1"
              elif [ "$${TERM%%-*}" = "screen" ]; then
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
    programs.direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
    time.timeZone = "America/Sao_Paulo";
    i18n.defaultLocale = "en_US.UTF-8";
    i18n.extraLocaleSettings = {
      LC_ADDRESS = "pt_BR.UTF-8";
      LC_IDENTIFICATION = "pt_BR.UTF-8";
      LC_MEASUREMENT = "pt_BR.UTF-8";
      LC_MONETARY = "pt_BR.UTF-8";
      LC_NAME = "pt_BR.UTF-8";
      LC_NUMERIC = "pt_BR.UTF-8";
      LC_PAPER = "pt_BR.UTF-8";
      LC_TELEPHONE = "pt_BR.UTF-8";
      LC_TIME = "pt_BR.UTF-8";
    };

    services.xserver = {
      enable = true;
      xkb = {
        variant = "abnt2";
        layout = "br";
      };
    };
    console.keyMap = "br-abnt2";
  };
}
