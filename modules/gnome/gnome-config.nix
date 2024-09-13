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
      gtk-theme="Graphite-Dark";
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
    };
    "org/gnome/settings-daemon/plugins/power" = {
      power-button-action="hibernate";
      sleep-inactive-ac-type="nothing";
    };
    # ========= GNOME SHELL ============
    "org/gnome/shell" = {
      enabled-extensions = [
        "appindicatorsupport@rgcjonas.gmail.com"
        "light-style@gnome-shell-extensions.gcampax.github.com"
        "Vitals@CoreCoding.com"
        "user-theme@gnome-shell-extensions.gcampax.github.com"
        "x11gestures@joseexposito.github.io"
        "gsconnect@andyholmes.github.io"
      ];
      disabled-extensions= [
        "windowsNavigator@gnome-shell-extensions.gcampax.github.com"
        "apps-menu@gnome-shell-extensions.gcampax.github.com"
      ];
    };
    "org/gnome/shell/extensions/user-theme".name = "Graphite-Dark";
    "org/honem/shell/extensions/vitals" = {
      hide-zeros = true;
      position-in-panel = "0";
      show-battery = false;
      show-temperature = true;
    };
    "org/gnome/shell/app-switcher".current-workspace-only = true;
  };
}
