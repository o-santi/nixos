{inputs, pkgs, ...}:

{
  config = {
    environment.systemPackages = with pkgs; [
      gnomeExtensions.appindicator
      gnomeExtensions.vitals
      gnomeExtensions.user-themes
      gnomeExtensions.blur-my-shell
      gnome.gnome-tweaks
      pkgs.orchis-theme
      pkgs.papirus-icon-theme
    ];

    environment.gnome.excludePackages = (with pkgs; [
      gnome-photos
      gnome-tour
    ]) ++ (with pkgs.gnome; [
      cheese # webcam tool
      gnome-music
      gnome-terminal
      gedit # text editor
      epiphany # web browser
      geary # email reader
      evince # document viewer
      gnome-characters
      totem # video player
      tali # poker game
      iagno # go game
      hitori # sudoku game
      atomix # puzzle game
    ]);
    services.xserver = {
      displayManager.gdm = {
        enable = true;
        wayland = false;
      };
      desktopManager.gnome.enable = true;
    };
    services.gnome.gnome-browser-connector.enable = true;
    programs.dconf.enable = true;

    home-manager.extraSpecialArgs = { inherit inputs; };
    home-manager.users.leonardo = {pkgs, ...}: {
      gtk = {
        enable = true;
        iconTheme = {
          name = "Papirus-Dark";
          package = pkgs.papirus-icon-theme;
        };
        theme.name = "Orchis-Teal-Dark";
      };
    };
  };
}
