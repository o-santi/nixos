{ config, lib, pkgs, ...}: with lib; {
  options.santi-modules.cosmic = {
    enable = mkEnableOption "Enable cosmic";
  };
  config = mkIf config.santi-modules.cosmic.enable {
    services.displayManager.cosmic-greeter.enable = true;
    services.desktopManager.cosmic.enable = true;
    services.system76-scheduler.enable = true;

    environment.cosmic.excludePackages = with pkgs; [
      cosmic-edit
    ];
  };
}
