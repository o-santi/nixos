{ config, lib, pkgs, ...}: with lib; {
  imports = [
    ./extensions.nix
  ];
  options.santi-modules.gnome = {
    enable = mkEnableOption "Enable gnome";
    extensions = mkOption {
      description = "Extensions to gnome";
      type = with types; attrsOf (submodule {
        options = {
          package = mkOption {
            type = package;
            description = "Extension package";
          };
          email = mkOption {
            type = nullOr str;
            default = null;
            description = "Extensions' maintainer email";
          };
          dconf-settings = mkOption {
            type = attrs;
            default = {};
            description = "Extra configuration to be passed to dconf";
          };
          enabled = mkEnableOption {
            description = "Enable extension";
          };
        };
      });
    };
  };
  config = mkIf config.santi-modules.gnome.enable {
    programs.dconf.enable = true;
    services.displayManager.gdm = {
      enable = true;
      wayland = true;
    };
    services.desktopManager.gnome.enable = true;
    services.xserver.excludePackages = [ pkgs.xterm ];
    services.udev.packages = [ pkgs.gnome-settings-daemon ];
    services.gnome = {
      gnome-browser-connector.enable = true;
      gnome-keyring.enable = true;
      core-apps.enable = false;
      core-developer-tools.enable = false;
      games.enable = false;
    };
    environment.gnome.excludePackages = with pkgs; [ gnome-tour gnome-user-docs ];
    security.pam.services = {
      login.enableGnomeKeyring = true;
      gdm.enableGnomeKeyring = true;
      gdm-autologin.enableGnomeKeyring = true;
      gdm-fingerprint.enableGnomeKeyring = true;
      gdm-password.enableGnomeKeyring = true;
    };
    
    home-manager.users.leonardo.dconf.settings = {
      "org/gnome/desktop/background" = {
        picture-uri = "${../../wallpaper.png}";
        picture-uri-dark = "${../../wallpaper.png}";
        picture-options = "zoom";
      };
      "org/gnome/desktop/interface" = {
        color-scheme="prefer-dark";
        enable-hot-corners=false;
        font-antialiasing="grayscale";
        font-hinting="slight";
        gtk-theme="Adwaita";
        cursor-theme="Hackneyed";
        icon-theme="Tela-brown-light";
        show-battery-percentage=true;
      };
      "org/gnome/settings-daemon/plugins/power" = { 
        power-button-action="hibernate";
        sleep-inactive-ac-type="nothing";
      };
      "org/gnome/mutter" = {
        dynamic-workspaces= true;
        edge-tiling= true;
        workspaces-only-on-primary= true;
        experimental-features = [ "scale-monitor-framebuffer" "variable-refresh-rate"];
      };
      "org/gnome/shell" = {
        disabled-extensions= [
          "windowsNavigator@gnome-shell-extensions.gcampax.github.com"
          "apps-menu@gnome-shell-extensions.gcampax.github.com"
        ];
      };
      "org/gnome/shell/app-switcher".current-workspace-only = true;
    };
  };
}
