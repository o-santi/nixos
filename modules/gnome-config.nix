{ ... }:
{
  dconf.settings = {
    "org/gnome/desktop/background" = {
      picture-uri = "${../wallpaper.png}";
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
        "blur-my-shell@aunetx"
        "light-style@gnome-shell-extensions.gcampax.github.com"
        "Vitals@CoreCoding.com"
        "user-theme@gnome-shell-extensions.gcampax.github.com"
        "x11gestures@joseexposito.github.io"
      ];
      disabled-extensions= [
        "windowsNavigator@gnome-shell-extensions.gcampax.github.com"
        "apps-menu@gnome-shell-extensions.gcampax.github.com"
      ];
    };
    "org/gnome/shell/extensions/user-theme".name = "Graphite-Dark";
    "org/gnome/shell/extensions/blur-my-shell/applications" = {
      blur=true;
      blur-on-overview=false;
      dynamic-opacity=false;
      brightness=0.65;
      enable-all=false;
      opacity=255;
      sigma=10;
      whitelist = ["Emacs"];
    };
    "org/honem/shell/extensions/vitals" = {
      hide-zeros = true;
      position-in-panel = "0";
      show-battery = false;
      show-temperature = true;
    };
    "org/gnome/shell/app-switcher".current-workspace-only = true;
  };
}
