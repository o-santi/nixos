{inputs, pkgs, ...}:
{
  config = {
    # enable buffering for better perfomance
    programs.dconf.enable = true;
    nixpkgs.overlays = [
      (final: prev: {
        gnome = prev.gnome.overrideScope' (gnomeFinal: gnomePrev: {
          mutter = gnomePrev.mutter.overrideAttrs ( old: {
            src = pkgs.fetchgit {
              url = "https://gitlab.gnome.org/vanvugt/mutter.git";
              # GNOME 45: triple-buffering-v4-45
              rev = "0b896518b2028d9c4d6ea44806d093fd33793689";
              sha256 = "sha256-mzNy5GPlB2qkI2KEAErJQzO//uo8yO0kPQUwvGDwR4w=";
            };
          } );
        });
      })
    ];
    environment.systemPackages = with pkgs; [
      gnome.gnome-tweaks
      pkgs.orchis-theme
      pkgs.papirus-icon-theme
    ] ++ (with gnomeExtensions; [
      appindicator
      vitals
      user-themes
      blur-my-shell
      gesture-improvements
    ]);

    environment.gnome.excludePackages = (with pkgs; [
      gnome-photos
      gnome-tour
      gedit
    ]) ++ (with pkgs.gnome; [
      cheese # webcam tool
      gnome-music
      gnome-terminal
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
    services.udev.packages = [ pkgs.gnome.gnome-settings-daemon ];
    services.gnome = {
      gnome-browser-connector.enable = true;
      gnome-keyring.enable = true;
    };
  };
}
