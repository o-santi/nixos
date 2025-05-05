{ pkgs, inputs, config, lib,  ...}: let
  inherit (lib) mkEnableOption mkIf;
  emacs = pkgs.callPackage ./package.nix {};
in {
  options.santi-modules.emacs.enable = mkEnableOption "Enable emacs configuration";
  config = mkIf config.santi-modules.emacs.enable {
    nixpkgs.overlays = [ inputs.emacs-overlay.overlays.default ];
    environment.systemPackages = [
      emacs
    ];
    fonts.packages = with pkgs; [
      nerd-fonts.dejavu-sans-mono
    ];
  };
}

