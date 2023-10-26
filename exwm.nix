{pkgs, inputs, system, ...}:
{
  services.xserver = {
    enable = true;
    updateDbusEnvironment = true;
    windowManager.session = pkgs.lib.singleton {
      name = "exwm";
      start = ''
        dbus-launch ${inputs.emacs.packages.x86_64-linux.default}/bin/emacs -mm
      '';
    };
    desktopManager = {
      default = "none";
    };
    displayManager = {
      lightdm = {
        enable = true;
      };
      autoLogin = {
        enable = true;
        user = "leonardo";
      };
    };
  };
}
