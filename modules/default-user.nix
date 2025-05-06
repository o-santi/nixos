{ config, lib, pkgs, ...}: with lib; let
  cfg = config.santi-modules;
in {
  options.santi-modules = { 
    default-user.enable = mkOption {
      type = types.bool;
      default = true;
      description = "Enables default user configuration and ssh access";
    };
  };
  config = mkIf config.santi-modules.default-user.enable {
    environment.systemPackages = with pkgs; [
      deploy-rs
      jujutsu
    ] ++ (if cfg.mu.enable then [ pkgs.parallel ] else []);
    users.mutableUsers = false;
    users.users.leonardo = {
      isNormalUser = true;
      description = "leonardo";
      extraGroups = [ "networkmanager" "wheel" ];
      shell = pkgs.bashInteractive;
    };
    programs.ssh.startAgent = true;
    services.openssh = {
      enable = true;
      settings = {
        KbdInteractiveAuthentication = false;
        PasswordAuthentication = false;
      };
    };
  };
}
