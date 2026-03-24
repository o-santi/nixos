{ lib, config, ...}: {
  imports = [   
    ./blog.nix
    ./cgit.nix
    ./cloudflared.nix
    ./immich.nix
    ./syncthing.nix
    ./tailscale.nix
    ./vaultwarden.nix
    ./pocket.nix
  ];
}
