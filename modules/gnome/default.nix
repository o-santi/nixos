{ config, lib, pkgs, ...}: with lib; {
  options.santi-modules.gnome.enable = mkEnableOption "Enable gnome";
  config = mkIf config.santi-modules.gnome.enable {
    programs.dconf.enable = true;
    environment.systemPackages = with pkgs; [
      gnome-tweaks
      tela-icon-theme
      hackneyed
    ] ++ (with gnomeExtensions; [
      appindicator
      vitals
      user-themes
      graphite-gtk-theme
      x11-gestures
      gsconnect
      openweather-refined
    ]);
    
    environment.gnome.excludePackages = with pkgs; [
      gnome-photos
      gnome-tour
      gedit
      cheese
      gnome-terminal
      epiphany # web browser
      geary # email reader
      evince # document viewer
      totem # video player
      gnome-music
      gnome-characters
      tali # poker game
      iagno # go game
      hitori # sudoku game
      atomix # puzzle game
    ];
    services.xserver = {
      displayManager.gdm = {
        enable = true;
        wayland = true;
      };
      desktopManager.gnome.enable = true;
    };
    services.udev.packages = [ pkgs.gnome-settings-daemon ];
    services.gnome = {
      gnome-browser-connector.enable = true;
      gnome-keyring.enable = true;
    };
  };
}
