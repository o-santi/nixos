{ pkgs, inputs, ... }:
{
  imports =
    [ inputs.nixos-hardware.nixosModules.raspberry-pi-4 ];
  # hardware = {
  #   raspberry-pi."4".apply-overlays-dtmerge.enable = true;
  # };
  nixpkgs.overlays = [
    (final: super: {
      makeModulesClosure = x:
        super.makeModulesClosure (x // { allowMissing = true; });
    })
  ];

  networking.hostName = "iori";
  system.stateVersion = "23.11";
}
