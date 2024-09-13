{ config, lib, pkgs, ...}: with lib; {
  options.santi-modules.basic.enable = mkOption {
    type = types.bool;
    default = true;
    description = "Enables basic configuration on nix, nixpkgs and bash prompt.";
  };
  config = mkIf config.santi-modules.basic.enable {
    nix = {
      package = pkgs.lib.mkForce pkgs.nixVersions.nix_2_23;
      settings = {
        trusted-users = [ "root" "leonardo" ];
        auto-optimise-store = true;
      };
      gc = {
        automatic = true;
        dates = "weekly";
        options = "--delete-older-than 30d";
      };
    };

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
