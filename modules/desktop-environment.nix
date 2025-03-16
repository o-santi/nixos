{ config, lib, pkgs, ... }: with lib; {
  options.santi-modules.desktop-environment.enable = mkEnableOption "Enable default desktop-environment";
  config = mkIf config.santi-modules.desktop-environment.enable {
    santi-modules = {
      font-config.enable = true;
      emacs.enable = true;
      gnome.enable = true;
      games.enable = true;
      mu.enable = true;
      default-user.enable = true;
      basic.enable = true;
    };

    services.printing.enable = false; # disabled until CUPS CVE is fixed
    services.pulseaudio.enable = false;
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
  };
}
