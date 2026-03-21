{ lib, config, ...}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.santi-modules;
in {
  imports = [   
    ./blog.nix
    ./cgit.nix
    ./cloudflared.nix
    ./immich.nix
    ./syncthing.nix
    ./tailscale.nix
  ];
}
