{ config, lib, pkgs, ... } : let
  inherit (builtins) attrNames attrValues;
  cfg = config.santi-modules.gnome;
  enabled-extensions = lib.filterAttrs (key: conf: conf.enabled) cfg.extensions;
in {
  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      gnome-tweaks
      tela-icon-theme
      hackneyed
    ] ++ map (pkg-name: pkgs.gnomeExtensions.${pkg-name})
      (attrNames enabled-extensions);
    santi-modules.gnome.extensions = {
      appindicator = {
        email = "appindicatorsupport@rgcjonas.gmail.com";
        enabled = true;
      };
      x11-gestures = {
        email = "x11gestures@joseexposito.github.io";
        enabled = config.santi-modules.has-touchpad;
      };
      system-monitor = {
        email = "system-monitor@gnome-shell-extensions.gcampax.github.com";
        enabled = true;
      };
    };
    home-manager.users.leonardo.dconf.settings = lib.mkMerge ([{
      "org/gnome/shell" = {
        enabled-extensions = map (pkg: pkg.email) (attrValues enabled-extensions);
      };
    }] ++ (map (pkg: pkg.dconf-settings) (attrValues enabled-extensions)));
  };
}
