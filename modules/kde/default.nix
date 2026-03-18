{ config, lib, pkgs, inputs, ...}: with lib; {
  options.santi-modules.kde = { 
    enable = mkEnableOption "Enable kde";
  };
  config = mkIf config.santi-modules.kde.enable {
    services.desktopManager.plasma6.enable = true;
    services.displayManager.sddm = {
      enable = true;
      wayland.enable = true;
    };
    services.displayManager.plasma-login-manager = {
      enable = true;
    };
    programs.kde-pim = {
      enable = true;
      merkuro = true;
    };
    environment.systemPackages = with pkgs.kdePackages; [
      kdepim-addons
      akonadi-calendar
      libkdepim
      akonadi-import-wizard
      pkgs.papirus-icon-theme
    ];
    environment.plasma6.excludePackages = with pkgs.kdePackages; [
      konsole
      elisa
    ];
  };
}
