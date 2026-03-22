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

    networking.nameservers = [ "1.1.1.1" "9.9.9.9" ];
    
    nixpkgs = {
      config.allowUnfree = true;
      config.allowUnfreePredicate = _: true;
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
  };
}
