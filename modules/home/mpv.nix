{ config, lib, pkgs, ...}: with lib; let
  cfg = config.santi-modules;
in {
  options.santi-modules.mpv.enable = mkEnableOption "Enable mpv";
  config = mkIf cfg.mpv.enable {
    home-manager.users.leonardo = {
      programs.mpv = {
        enable = true;
        scripts = with pkgs.mpvScripts; [
          uosc
          sponsorblock
          webtorrent-mpv-hook
        ];
        config = {
          profile = "high-quality";
        };
      };
    };
  };
}
