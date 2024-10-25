santi-modules: 
{ lib, ... }: lib.optionalAttrs santi-modules.gnome.enable {
  dconf.settings = {
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
      icon-theme="Tela-brown-light";
      show-battery-percentage=true;
    };
    "org/gnome/desktop/peripherals/touchpad" = {
      edge-scrolling-enabled=false;
      natural-scroll=true;
      tap-to-click=true;
      two-finger-scrolling-enabled=true;
    };
    "org/gnome/mutter" = {
      dynamic-workspaces= true;
      edge-tiling= true;
      workspaces-only-on-primary= true;
      experimental-features = [ "scale-monitor-framebuffer" "variable-refresh-rate"];
    };
    "org/gnome/settings-daemon/plugins/power" = {
      power-button-action="hibernate";
      sleep-inactive-ac-type="nothing";
    };
    # ========= GNOME SHELL ============
    "org/gnome/shell" = {
      enabled-extensions = [
        "appindicatorsupport@rgcjonas.gmail.com"
        "user-theme@gnome-shell-extensions.gcampax.github.com"
        "x11gestures@joseexposito.github.io"
        "openbar@neuromorph"
        "system-monitor@gnome-shell-extensions.gcampax.github.com"
      ];
      disabled-extensions= [
        "windowsNavigator@gnome-shell-extensions.gcampax.github.com"
        "apps-menu@gnome-shell-extensions.gcampax.github.com"
      ];
    };
    "org/gnome/shell/extensions/user-theme".name = "Graphite";
    "org/gnome/shell/app-switcher".current-workspace-only = true;
    "org/gnome/shell/extensions/openbar" = {
      bartype="Islands";
      apply-accent-shell= true;
      apply-all-shell = false;
      apply-menu-notif = true;
      apply-menu-shell = true;
      autotheme-dark="Dark";
      autotheme-font= true;
      autotheme-light= "Light";
      autotheme-refresh= true;
      color-scheme="prefer-dark";
      cust-margin-wmax=false;
      margin = 0.0;
      wmaxbar = true;
      border-wmax = true;
    };
  };
}
